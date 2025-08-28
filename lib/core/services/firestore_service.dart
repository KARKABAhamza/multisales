import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';

/// Result wrapper for Firestore operations
class FirestoreResult<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;

  FirestoreResult._({
    required this.isSuccess,
    this.data,
    this.errorMessage,
  });

  factory FirestoreResult.success(T? data) {
    return FirestoreResult._(isSuccess: true, data: data);
  }

  factory FirestoreResult.failure(String errorMessage) {
    return FirestoreResult._(isSuccess: false, errorMessage: errorMessage);
  }
}

/// Firestore Service for MultiSales Client App
/// Handles all Firestore database operations with proper error handling
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Profile Management

  /// Create a user profile document in Firestore
  Future<FirestoreResult<void>> createUserProfile({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set(userData);
      return FirestoreResult.success(null);
    } catch (e) {
      return FirestoreResult.failure(
          'Failed to create user profile: ${e.toString()}');
    }
  }

  /// Get a user profile document from Firestore
  Future<FirestoreResult<Map<String, dynamic>>> getUserProfile({
    required String userId,
  }) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return FirestoreResult.success(doc.data()!);
      } else {
        return FirestoreResult.failure('User profile not found');
      }
    } catch (e) {
      return FirestoreResult.failure(
          'Failed to get user profile: ${e.toString()}');
    }
  }

  /// Update a user profile document in Firestore
  Future<FirestoreResult<void>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update(userData);
      return FirestoreResult.success(null);
    } catch (e) {
      return FirestoreResult.failure(
          'Failed to update user profile: ${e.toString()}');
    }
  }

  // Generic method to create a document
  Future<Map<String, dynamic>> createDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).set(data);
      return {'success': true, 'message': 'Document created successfully'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Generic method to read a document
  Future<Map<String, dynamic>> getDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(documentId).get();
      if (doc.exists) {
        return {'success': true, 'data': doc.data()};
      } else {
        return {'success': false, 'error': 'Document not found'};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Generic method to update a document
  Future<Map<String, dynamic>> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).update(data);
      return {'success': true, 'message': 'Document updated successfully'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Generic method to delete a document
  Future<Map<String, dynamic>> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
      return {'success': true, 'message': 'Document deleted successfully'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Generic method to get a collection
  Future<Map<String, dynamic>> getCollection({
    required String collection,
    Query<Map<String, dynamic>>? query,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot;
      if (query != null) {
        snapshot = await query.get();
      } else {
        snapshot = await _firestore.collection(collection).get();
      }

      final List<Map<String, dynamic>> documents =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();

      return {'success': true, 'data': documents};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Stream method for real-time updates
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collection,
    Query<Map<String, dynamic>>? query,
  }) {
    if (query != null) {
      return query.snapshots();
    }
    return _firestore.collection(collection).snapshots();
  }

  // User-specific methods
  Future<Map<String, dynamic>> getUserData(String userId) async {
    return await getDocument(collection: 'users', documentId: userId);
  }

  Future<Map<String, dynamic>> updateUserData(
      String userId, Map<String, dynamic> data) async {
    return await updateDocument(
        collection: 'users', documentId: userId, data: data);
  }

  Future<Map<String, dynamic>> createUserData(
      String userId, Map<String, dynamic> data) async {
    return await createDocument(
        collection: 'users', documentId: userId, data: data);
  }

  // Specific user methods with proper return types
  Future<FirestoreResult<UserModel>> getUser(String userId) async {
    try {
      final result = await getUserData(userId);
      if (result['success'] == true && result['data'] != null) {
        final userModel =
            UserModel.fromJson(result['data'] as Map<String, dynamic>);
        return FirestoreResult.success(userModel);
      } else {
        return FirestoreResult.failure(result['error'] ?? 'User not found');
      }
    } catch (e) {
      return FirestoreResult.failure('Failed to get user: $e');
    }
  }

  Future<FirestoreResult<UserModel>> createUser(UserModel userModel) async {
    try {
      final result = await createUserData(userModel.id, userModel.toJson());
      if (result['success'] == true) {
        return FirestoreResult.success(userModel);
      } else {
        return FirestoreResult.failure(
            result['error'] ?? 'Failed to create user');
      }
    } catch (e) {
      return FirestoreResult.failure('Failed to create user: $e');
    }
  }

  Future<FirestoreResult<UserModel>> updateUser(UserModel userModel) async {
    try {
      final result = await updateUserData(userModel.id, userModel.toJson());
      if (result['success'] == true) {
        return FirestoreResult.success(userModel);
      } else {
        return FirestoreResult.failure(
            result['error'] ?? 'Failed to update user');
      }
    } catch (e) {
      return FirestoreResult.failure('Failed to update user: $e');
    }
  }
}
