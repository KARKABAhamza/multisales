// ignore_for_file: prefer_final_fields, unnecessary_overrides

import 'package:flutter/foundation.dart';
import '../models/user_account.dart';
import '../models/service_subscription.dart';
import '../models/invoice.dart';

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
