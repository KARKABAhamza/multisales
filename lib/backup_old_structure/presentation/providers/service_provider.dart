import 'package:flutter/foundation.dart';

/// Service Management Provider for MultiSales Client App
/// Handles services, products, quotations, orders, and support tickets
class ServiceProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  // Service & Product Data
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _clientOrders = [];
  final List<Map<String, dynamic>> _quotations = [];
  final List<Map<String, dynamic>> _supportTickets = [];
  List<Map<String, dynamic>> _invoices = [];
  Map<String, dynamic>? _clientAccountStatus;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get services => _services;
  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get clientOrders => _clientOrders;
  List<Map<String, dynamic>> get quotations => _quotations;
  List<Map<String, dynamic>> get supportTickets => _supportTickets;
  List<Map<String, dynamic>> get invoices => _invoices;
  Map<String, dynamic>? get clientAccountStatus => _clientAccountStatus;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // 1. Load Client Account Status
  Future<bool> loadClientAccountStatus(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulated data - replace with actual Firestore calls
      await Future.delayed(const Duration(milliseconds: 500));

      _clientAccountStatus = {
        'clientId': clientId,
        'accountStatus': 'active', // active, suspended, pending
        'serviceStatus': 'operational', // operational, maintenance, issues
        'subscriptions': [
          {
            'id': 'sub_001',
            'name': 'Internet Pro',
            'status': 'active',
            'monthlyFee': 299.0,
            'nextBilling': '2025-08-30',
            'dataUsage': {'used': 150, 'total': 500}, // GB
          },
          {
            'id': 'sub_002',
            'name': 'Cloud Storage',
            'status': 'active',
            'monthlyFee': 49.0,
            'nextBilling': '2025-08-15',
            'storageUsage': {'used': 25, 'total': 100}, // GB
          }
        ],
        'pendingInvoices': 2,
        'totalOutstanding': 648.0,
        'lastPayment': '2025-07-01',
        'supportTicketsOpen': 1,
      };

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load account status: $e');
      _setLoading(false);
      return false;
    }
  }

  // 2. Load Products & Services Catalog
  Future<bool> loadProductsCatalog() async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      _products = [
        {
          'id': 'prod_001',
          'name': 'Internet Fiber Pro',
          'category': 'Internet',
          'description': 'High-speed fiber internet up to 1Gbps',
          'price': 399.0,
          'currency': 'MAD',
          'features': [
            '1Gbps Download',
            '500Mbps Upload',
            '24/7 Support',
            'Free Installation'
          ],
          'imageUrl': 'https://example.com/fiber-pro.jpg',
          'availability': 'available',
          'rating': 4.8,
          'reviewCount': 324,
        },
        {
          'id': 'prod_002',
          'name': 'Business Cloud Suite',
          'category': 'Cloud Services',
          'description': 'Complete cloud solution for businesses',
          'price': 899.0,
          'currency': 'MAD',
          'features': [
            '500GB Storage',
            'Email Hosting',
            'Backup Service',
            'Security Suite'
          ],
          'imageUrl': 'https://example.com/cloud-suite.jpg',
          'availability': 'available',
          'rating': 4.6,
          'reviewCount': 156,
        },
        {
          'id': 'prod_003',
          'name': 'Mobile Business Plan',
          'category': 'Mobile',
          'description': 'Unlimited calls and data for business',
          'price': 199.0,
          'currency': 'MAD',
          'features': [
            'Unlimited Calls',
            '50GB Data',
            'International Roaming',
            'Multi-SIM'
          ],
          'imageUrl': 'https://example.com/mobile-business.jpg',
          'availability': 'available',
          'rating': 4.5,
          'reviewCount': 89,
        },
      ];

      _services = [
        {
          'id': 'serv_001',
          'name': 'Technical Support',
          'category': 'Support',
          'description': '24/7 technical assistance',
          'price': 0.0, // Free for subscribers
          'type': 'ongoing',
          'availability': 'always',
        },
        {
          'id': 'serv_002',
          'name': 'On-site Installation',
          'category': 'Installation',
          'description': 'Professional installation service',
          'price': 150.0,
          'currency': 'MAD',
          'type': 'one-time',
          'estimatedDuration': '2-3 hours',
        },
      ];

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load products catalog: $e');
      _setLoading(false);
      return false;
    }
  }

  // 3. Request Quotation
  Future<bool> requestQuotation({
    required String clientId,
    required List<String> productIds,
    required Map<String, dynamic> clientDetails,
    String? specialRequirements,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      final quotationId = 'quo_${DateTime.now().millisecondsSinceEpoch}';
      final newQuotation = {
        'id': quotationId,
        'clientId': clientId,
        'productIds': productIds,
        'clientDetails': clientDetails,
        'specialRequirements': specialRequirements,
        'status': 'pending', // pending, processing, completed, expired
        'requestedAt': DateTime.now().toIso8601String(),
        'validUntil':
            DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        'estimatedPrice': 0.0, // Will be filled by sales team
        'salesRepId': null,
      };

      _quotations.add(newQuotation);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to submit quotation request: $e');
      _setLoading(false);
      return false;
    }
  }

  // 4. Place Order
  Future<bool> placeOrder({
    required String clientId,
    required List<Map<String, dynamic>> orderItems,
    required Map<String, dynamic> billingAddress,
    required Map<String, dynamic> installationAddress,
    String? notes,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      final orderId = 'ord_${DateTime.now().millisecondsSinceEpoch}';
      final totalAmount = orderItems.fold<double>(
        0.0,
        (sum, item) => sum + (item['price'] * item['quantity']),
      );

      final newOrder = {
        'id': orderId,
        'clientId': clientId,
        'items': orderItems,
        'billingAddress': billingAddress,
        'installationAddress': installationAddress,
        'notes': notes,
        'status':
            'submitted', // submitted, confirmed, in_progress, completed, cancelled
        'totalAmount': totalAmount,
        'currency': 'MAD',
        'orderedAt': DateTime.now().toIso8601String(),
        'estimatedDelivery':
            DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'trackingNumber': 'MS$orderId',
        'paymentStatus': 'pending', // pending, paid, failed
      };

      _clientOrders.add(newOrder);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to place order: $e');
      _setLoading(false);
      return false;
    }
  }

  // 5. Create Support Ticket
  Future<bool> createSupportTicket({
    required String clientId,
    required String subject,
    required String description,
    required String priority, // low, medium, high, urgent
    required String category, // technical, billing, account, service
    List<String>? attachments,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final ticketId = 'TKT_${DateTime.now().millisecondsSinceEpoch}';
      final newTicket = {
        'id': ticketId,
        'ticketNumber': ticketId,
        'clientId': clientId,
        'subject': subject,
        'description': description,
        'priority': priority,
        'category': category,
        'status':
            'open', // open, in_progress, waiting_customer, resolved, closed
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'assignedTo': null,
        'attachments': attachments ?? [],
        'responses': [],
        'estimatedResolution': _getEstimatedResolution(priority),
      };

      _supportTickets.add(newTicket);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create support ticket: $e');
      _setLoading(false);
      return false;
    }
  }

  // 6. Load Client Orders
  Future<bool> loadClientOrders(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Simulated order history
      _clientOrders = [
        {
          'id': 'ord_1722345600000',
          'clientId': clientId,
          'items': [
            {'name': 'Internet Fiber Pro', 'quantity': 1, 'price': 399.0}
          ],
          'status': 'completed',
          'totalAmount': 399.0,
          'orderedAt': '2025-07-15T10:30:00Z',
          'completedAt': '2025-07-20T14:45:00Z',
          'trackingNumber': 'MSord_1722345600000',
        },
        {
          'id': 'ord_1722432000000',
          'clientId': clientId,
          'items': [
            {'name': 'Business Cloud Suite', 'quantity': 1, 'price': 899.0}
          ],
          'status': 'in_progress',
          'totalAmount': 899.0,
          'orderedAt': '2025-07-25T09:15:00Z',
          'estimatedDelivery': '2025-08-05T12:00:00Z',
          'trackingNumber': 'MSord_1722432000000',
        },
      ];

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load orders: $e');
      _setLoading(false);
      return false;
    }
  }

  // 7. Load Client Invoices
  Future<bool> loadClientInvoices(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _invoices = [
        {
          'id': 'inv_001',
          'clientId': clientId,
          'invoiceNumber': 'MS-2025-001',
          'amount': 399.0,
          'currency': 'MAD',
          'status': 'paid',
          'issueDate': '2025-07-01',
          'dueDate': '2025-07-31',
          'paidDate': '2025-07-15',
          'description': 'Internet Fiber Pro - July 2025',
        },
        {
          'id': 'inv_002',
          'clientId': clientId,
          'invoiceNumber': 'MS-2025-002',
          'amount': 899.0,
          'currency': 'MAD',
          'status': 'pending',
          'issueDate': '2025-08-01',
          'dueDate': '2025-08-31',
          'description': 'Business Cloud Suite - August 2025',
        },
      ];

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load invoices: $e');
      _setLoading(false);
      return false;
    }
  }

  String _getEstimatedResolution(String priority) {
    switch (priority) {
      case 'urgent':
        return DateTime.now().add(const Duration(hours: 2)).toIso8601String();
      case 'high':
        return DateTime.now().add(const Duration(hours: 8)).toIso8601String();
      case 'medium':
        return DateTime.now().add(const Duration(days: 1)).toIso8601String();
      default:
        return DateTime.now().add(const Duration(days: 3)).toIso8601String();
    }
  }
}
