// lib/core/services/optimized_auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/auth_result.dart';
import '../models/cached_data.dart';
import '../models/queued_operation.dart';

/// Optimized Authentication Service with Performance Enhancements
class OptimizedAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Caching layer
  final Map<String, CachedData> _cache = {};
  static const Duration _cacheTimeout = Duration(minutes: 5);

  // Rate limiting
  final Map<String, List<DateTime>> _requestHistory = {};
  static const int _maxRequestsPerMinute = 60;

  // Background sync queue
  final List<QueuedOperation> _operationQueue = [];

  /// Optimized sign-in with parallel operations and caching
  Future<AuthResult> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Start performance trace
      final stopwatch = Stopwatch()..start();

      // Parallel operations where possible
      final futures = await Future.wait([
        _auth.signInWithEmailAndPassword(email: email, password: password),
        _checkAccountLockoutCached(email), // Use cached data if available
      ]);

      final UserCredential credential = futures[0] as UserCredential;
      final bool isLocked = futures[1] as bool;

      if (isLocked) {
        await _auth.signOut();
        return AuthResult.failure('Account temporarily locked');
      }

      final user = credential.user;
      if (user == null) {
        return AuthResult.failure('Authentication failed');
      }

      // Check email verification
      if (!user.emailVerified) {
        await _auth.signOut();
        return AuthResult.failure('Please verify your email address');
      }

      // Queue non-critical operations for background processing
      _queueBackgroundOperations(user);

      stopwatch.stop();
      debugPrint('Auth flow completed in ${stopwatch.elapsedMilliseconds}ms');

      return AuthResult.success(user);
    } catch (e) {
      if (e is FirebaseAuthException) {
        return AuthResult.failure(_getAuthErrorMessage(e.code));
      }
      return AuthResult.failure('Authentication failed: ${e.toString()}');
    }
  }

  /// Check account lockout with caching
  Future<bool> _checkAccountLockoutCached(String email) async {
    final cacheKey = 'lockout_$email';
    final cached = _cache[cacheKey];

    if (cached != null && !cached.isExpired) {
      return cached.data as bool;
    }

    try {
      final doc =
          await _firestore.collection('account_lockouts').doc(email).get();

      final isLocked = doc.exists &&
          (doc.data()?['lockedUntil'] as Timestamp?)
                  ?.toDate()
                  .isAfter(DateTime.now()) ==
              true;

      // Cache the result
      _cache[cacheKey] = CachedData(isLocked, DateTime.now());

      return isLocked;
    } catch (e) {
      // If check fails, assume not locked
      return false;
    }
  }

  /// Queue non-critical operations for background processing
  void _queueBackgroundOperations(User user) {
    // Security event logging
    _queueOperation(QueuedOperation(
      type: 'security_event',
      data: {
        'userId': user.uid,
        'event': 'sign_in_success',
        'timestamp': FieldValue.serverTimestamp(),
        'metadata': {
          'email': user.email,
          'lastSignIn': user.metadata.lastSignInTime?.toIso8601String(),
        }
      },
    ));

    // Session tracking
    _queueOperation(QueuedOperation(
      type: 'session_update',
      data: {
        'userId': user.uid,
        'lastActivity': FieldValue.serverTimestamp(),
        'deviceInfo': _getDeviceInfo(),
      },
    ));

    // User profile update
    _queueOperation(QueuedOperation(
      type: 'profile_update',
      data: {
        'userId': user.uid,
        'lastLoginAt': FieldValue.serverTimestamp(),
      },
    ));
  }

  /// Queue operation for background sync
  Future<void> _queueOperation(QueuedOperation operation) async {
    _operationQueue.add(operation);

    // Try immediate sync if online
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      _processQueue();
    }
  }

  /// Process queued operations in batches
  Future<void> _processQueue() async {
    if (_operationQueue.isEmpty) return;

    try {
      // Group operations by type for batch processing
      final batches = <String, List<QueuedOperation>>{};

      while (_operationQueue.isNotEmpty) {
        final operation = _operationQueue.removeAt(0);
        batches[operation.type] ??= [];
        batches[operation.type]!.add(operation);

        // Process in batches of 10
        if (batches[operation.type]!.length >= 10) {
          await _processBatch(operation.type, batches[operation.type]!);
          batches[operation.type]!.clear();
        }
      }

      // Process remaining operations
      for (final entry in batches.entries) {
        if (entry.value.isNotEmpty) {
          await _processBatch(entry.key, entry.value);
        }
      }
    } catch (e) {
      debugPrint('Error processing operation queue: $e');
    }
  }

  /// Process batch of operations
  Future<void> _processBatch(
      String type, List<QueuedOperation> operations) async {
    switch (type) {
      case 'security_event':
        await _batchSecurityEvents(operations);
        break;
      case 'session_update':
        await _batchSessionUpdates(operations);
        break;
      case 'profile_update':
        await _batchProfileUpdates(operations);
        break;
    }
  }

  /// Batch security event logging
  Future<void> _batchSecurityEvents(List<QueuedOperation> operations) async {
    final batch = _firestore.batch();

    for (final operation in operations) {
      final ref = _firestore.collection('security_events').doc();
      batch.set(ref, operation.data);
    }

    await batch.commit();
  }

  /// Batch session updates
  Future<void> _batchSessionUpdates(List<QueuedOperation> operations) async {
    final batch = _firestore.batch();

    for (final operation in operations) {
      final userId = operation.data['userId'] as String;
      final ref = _firestore.collection('user_sessions').doc(userId);
      batch.update(ref, operation.data);
    }

    await batch.commit();
  }

  /// Batch profile updates
  Future<void> _batchProfileUpdates(List<QueuedOperation> operations) async {
    final batch = _firestore.batch();

    for (final operation in operations) {
      final userId = operation.data['userId'] as String;
      final ref = _firestore.collection('users').doc(userId);
      batch.update(ref, operation.data);
    }

    await batch.commit();
  }

  /// Rate limiting check
  Future<bool> canMakeRequest(String operation) async {
    final now = DateTime.now();
    final history = _requestHistory[operation] ?? [];

    // Remove requests older than 1 minute
    history.removeWhere((time) => now.difference(time).inMinutes > 1);

    if (history.length >= _maxRequestsPerMinute) {
      return false;
    }

    history.add(now);
    _requestHistory[operation] = history;
    return true;
  }

  /// Get cached user profile with fallback
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final cacheKey = 'profile_$userId';
    final cached = _cache[cacheKey];

    if (cached != null && !cached.isExpired) {
      return cached.data as Map<String, dynamic>?;
    }

    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _cache[cacheKey] = CachedData(data, DateTime.now());
        return data;
      }

      return null;
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  /// Clear expired cache entries
  void _cleanupExpiredCache() {
    final now = DateTime.now();
    _cache.removeWhere(
        (key, value) => now.difference(value.timestamp) > _cacheTimeout);
  }

  /// Get device information for tracking
  Map<String, dynamic> _getDeviceInfo() {
    return {
      'platform': defaultTargetPlatform.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Convert Firebase Auth error codes to user-friendly messages
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters long.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  /// Initialize the service
  Future<void> initialize() async {
    // Setup periodic cache cleanup
    Stream.periodic(const Duration(minutes: 10))
        .listen((_) => _cleanupExpiredCache());

    // Setup network connectivity listener for queue processing
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _processQueue();
      }
    });
  }

  /// Dispose resources
  void dispose() {
    _cache.clear();
    _requestHistory.clear();
    _operationQueue.clear();
  }
}
