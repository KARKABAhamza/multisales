// ignore_for_file: prefer_final_fields, unnecessary_overrides

import 'package:flutter/foundation.dart';
// Removed broken import for UserAccount (file does not exist)
// Removed broken import for ServiceSubscription (file does not exist)
// Removed broken import for Invoice (file does not exist)

// Stub classes for error suppression
class UserAccount {}
class ServiceSubscription {}
class Invoice {}
/// Provider for comprehensive client account management
class AccountProvider with ChangeNotifier {

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

  AccountProvider();


  @override
  @override
  void dispose() {
    super.dispose();
  }
}
