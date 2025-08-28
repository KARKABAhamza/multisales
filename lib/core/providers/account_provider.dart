import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/user_account.dart';
import '../models/service_subscription.dart';
import '../models/invoice.dart';
import 'optimized_auth_provider.dart';

/// Provider for comprehensive client account management
class AccountProvider with ChangeNotifier {
  final OptimizedAuthProvider _authProvider;
  final FirestoreService _firestoreService = FirestoreService();

  // Account state
  UserAccount? _userAccount;
  List<ServiceSubscription> _subscriptions = [];
  List<Invoice> _invoices = [];
  List<Map<String, dynamic>> _requestHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserAccount? get userAccount => _userAccount;
  List<ServiceSubscription> get subscriptions => _subscriptions;
  List<Invoice> get invoices => _invoices;
  List<Map<String, dynamic>> get requestHistory => _requestHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AccountProvider(this._authProvider) {
    _authProvider.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() {
    if (_authProvider.isAuthenticated) {
      loadAccountData();
    } else {
      _clearAccountData();
    }
  }

  /// Load comprehensive account data
  Future<void> loadAccountData() async {
    if (!_authProvider.isAuthenticated) return;

    _setLoading(true);
    try {
      final userId = _authProvider.firebaseUser!.uid;

      // Load account details
      await _loadUserAccount(userId);

      // Load subscriptions, invoices, and history in parallel
      await Future.wait([
        _loadSubscriptions(userId),
        _loadInvoices(userId),
        _loadRequestHistory(userId),
      ]);

      _setError(null);
    } catch (e) {
      _setError('Failed to load account data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Load user account details
  Future<void> _loadUserAccount(String userId) async {
    final result = await _firestoreService.getDocument(
      collection: 'user_accounts',
      documentId: userId,
    );

    if (result['success'] && result['data'] != null) {
      _userAccount = UserAccount.fromMap(result['data']);
    }
  }

  /// Load service subscriptions
  Future<void> _loadSubscriptions(String userId) async {
    // Implementation for loading subscriptions
    // This would fetch from a 'subscriptions' collection
    _subscriptions = []; // Placeholder
  }

  /// Load invoices
  Future<void> _loadInvoices(String userId) async {
    // Implementation for loading invoices
    // This would fetch from an 'invoices' collection
    _invoices = []; // Placeholder
  }

  /// Load request history
  Future<void> _loadRequestHistory(String userId) async {
    // Implementation for loading request history
    // This would fetch from a 'requests' collection
    _requestHistory = []; // Placeholder
  }

  /// Update account information
  Future<bool> updateAccountInfo(Map<String, dynamic> updates) async {
    if (!_authProvider.isAuthenticated) return false;

    _setLoading(true);
    try {
      final userId = _authProvider.firebaseUser!.uid;
      final result = await _firestoreService.updateUserProfile(
        userId: userId,
        userData: updates,
      );

      if (result.isSuccess) {
        await _loadUserAccount(userId);
        return true;
      } else {
        _setError(result.errorMessage);
        return false;
      }
    } catch (e) {
      _setError('Failed to update account: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get account summary for dashboard
  Map<String, dynamic> getAccountSummary() {
    return {
      'total_subscriptions': _subscriptions.length,
      'active_subscriptions': _subscriptions.where((s) => s.isActive).length,
      'pending_invoices': _invoices.where((i) => i.isPending).length,
      'total_amount_due': _invoices
          .where((i) => i.isPending)
          .fold(0.0, (sum, invoice) => sum + invoice.amount),
      'recent_requests': _requestHistory.take(5).toList(),
    };
  }

  void _clearAccountData() {
    _userAccount = null;
    _subscriptions.clear();
    _invoices.clear();
    _requestHistory.clear();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}
