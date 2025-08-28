import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart' as cart;
import '../models/payment_method.dart' as payment;

/// Order management provider for MultiSales app
/// Handles shopping cart, orders, payments, and order tracking
class OrderProvider with ChangeNotifier {
  final FirestoreService _firestoreService;

  // Cart Management
  List<cart.CartItem> _cartItems = [];
  double _cartTotal = 0.0;
  double _cartSubtotal = 0.0;
  double _cartTax = 0.0;
  double _shippingCost = 0.0;
  String? _promoCode;
  double _discountAmount = 0.0;

  // Orders
  List<OrderModel> _orders = [];
  List<OrderModel> _recentOrders = [];
  OrderModel? _selectedOrder;

  // Payment
  List<payment.PaymentMethod> _paymentMethods = [];
  payment.PaymentMethod? _selectedPaymentMethod;

  // State management
  bool _isLoading = false;
  String? _errorMessage;
  bool _isProcessingOrder = false;
  bool _isInitialized = false;

  // Filters
  String _orderStatusFilter = 'all';
  DateTime? _orderDateFilter;

  OrderProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  // Getters
  List<cart.CartItem> get cartItems => _cartItems;
  double get cartTotal => _cartTotal;
  double get cartSubtotal => _cartSubtotal;
  double get cartTax => _cartTax;
  double get shippingCost => _shippingCost;
  String? get promoCode => _promoCode;
  double get discountAmount => _discountAmount;

  List<OrderModel> get orders => _orders;
  List<OrderModel> get recentOrders => _recentOrders;
  OrderModel? get selectedOrder => _selectedOrder;

  List<payment.PaymentMethod> get paymentMethods => _paymentMethods;
  payment.PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isProcessingOrder => _isProcessingOrder;
  bool get isInitialized => _isInitialized;

  String get orderStatusFilter => _orderStatusFilter;
  DateTime? get orderDateFilter => _orderDateFilter;

  // Computed getters
  int get cartItemCount =>
      _cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  bool get hasCartItems => _cartItems.isNotEmpty;
  bool get canCheckout => hasCartItems && _selectedPaymentMethod != null;

  List<OrderModel> get filteredOrders {
    var filtered = _orders;

    if (_orderStatusFilter != 'all') {
      filtered = filtered
          .where((order) => order.status == _orderStatusFilter)
          .toList();
    }

    if (_orderDateFilter != null) {
      filtered = filtered
          .where((order) =>
              order.createdAt.year == _orderDateFilter!.year &&
              order.createdAt.month == _orderDateFilter!.month &&
              order.createdAt.day == _orderDateFilter!.day)
          .toList();
    }

    return filtered;
  }

  Map<String, int> get orderStats {
    return {
      'total': _orders.length,
      'pending': _orders.where((o) => o.status == 'pending').length,
      'processing': _orders.where((o) => o.status == 'processing').length,
      'shipped': _orders.where((o) => o.status == 'shipped').length,
      'delivered': _orders.where((o) => o.status == 'delivered').length,
      'cancelled': _orders.where((o) => o.status == 'cancelled').length,
    };
  }

  /// Initialize order provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _setLoading(true);
      _clearError();

      await Future.wait([
        _loadOrders(),
        _loadPaymentMethods(),
        _loadCart(),
      ]);

      _isInitialized = true;
    } catch (e) {
      _setError('Failed to initialize order management: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Cart Management
  void addToCart({
    required String productId,
    required String productName,
    required double price,
    int quantity = 1,
    String? imageUrl,
    Map<String, String>? options,
  }) {
    try {
      final existingIndex = _cartItems.indexWhere((item) =>
          item.productId == productId &&
          _mapEquals(item.options, options ?? {}));

      if (existingIndex != -1) {
        // Update existing item quantity
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + quantity,
        );
      } else {
        // Add new item
        _cartItems.add(cart.CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: productId,
          productName: productName,
          price: price,
          quantity: quantity,
          imageUrl: imageUrl,
          options: options ?? {},
          addedAt: DateTime.now(),
        ));
      }

      _calculateCartTotals();
      notifyListeners();

      // Save cart to storage (implementation)
      _saveCart();
    } catch (e) {
      _setError('Failed to add item to cart: $e');
    }
  }

  void removeFromCart(String cartItemId) {
    try {
      _cartItems.removeWhere((item) => item.id == cartItemId);
      _calculateCartTotals();
      notifyListeners();
      _saveCart();
    } catch (e) {
      _setError('Failed to remove item from cart: $e');
    }
  }

  void updateCartItemQuantity(String cartItemId, int quantity) {
    try {
      if (quantity <= 0) {
        removeFromCart(cartItemId);
        return;
      }

      final index = _cartItems.indexWhere((item) => item.id == cartItemId);
      if (index != -1) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
        _calculateCartTotals();
        notifyListeners();
        _saveCart();
      }
    } catch (e) {
      _setError('Failed to update cart item: $e');
    }
  }

  void clearCart() {
    _cartItems.clear();
    _calculateCartTotals();
    notifyListeners();
    _saveCart();
  }

  /// Apply promo code
  Future<bool> applyPromoCode(String code) async {
    try {
      // Validate promo code (implementation)
      // For now, mock validation
      final mockPromoCodes = {
        'SAVE10': 0.10,
        'WELCOME20': 0.20,
        'STUDENT15': 0.15,
      };

      if (mockPromoCodes.containsKey(code.toUpperCase())) {
        _promoCode = code.toUpperCase();
        _discountAmount = _cartSubtotal * mockPromoCodes[code.toUpperCase()]!;
        _calculateCartTotals();
        notifyListeners();
        return true;
      } else {
        _setError('Invalid promo code');
        return false;
      }
    } catch (e) {
      _setError('Failed to apply promo code: $e');
      return false;
    }
  }

  void removePromoCode() {
    _promoCode = null;
    _discountAmount = 0.0;
    _calculateCartTotals();
    notifyListeners();
  }

  /// Calculate cart totals
  void _calculateCartTotals() {
    _cartSubtotal =
        _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    _cartTax = _cartSubtotal * 0.05; // 5% tax
    _shippingCost = _cartSubtotal > 100 ? 0.0 : 15.0; // Free shipping over 100
    _cartTotal = _cartSubtotal + _cartTax + _shippingCost - _discountAmount;
  }

  /// Create order from cart
  Future<OrderModel?> createOrder({
    required String shippingAddress,
    required String billingAddress,
    String? specialInstructions,
  }) async {
    if (!canCheckout) {
      _setError('Cannot create order: Invalid cart or payment method');
      return null;
    }

    try {
      _setProcessingOrder(true);
      _clearError();

      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      final order = OrderModel(
        id: orderId,
        userId: 'anonymous_user_${DateTime.now().millisecondsSinceEpoch}',
        items: List.from(_cartItems),
        subtotal: _cartSubtotal,
        tax: _cartTax,
        shippingCost: _shippingCost,
        discountAmount: _discountAmount,
        total: _cartTotal,
        status: 'pending',
        paymentMethod: _selectedPaymentMethod!,
        shippingAddress: shippingAddress,
        billingAddress: billingAddress,
        specialInstructions: specialInstructions,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        promoCode: _promoCode,
      );

      // Save to Firestore
      final result = await _firestoreService.createDocument(
        collection: 'orders',
        documentId: order.id,
        data: order.toJson(),
      );

      if (result['success'] == true) {
        // Add to local orders only if Firestore save succeeded
        _orders.insert(0, order);
        _updateRecentOrders();

        // Clear cart after successful order
        clearCart();

        notifyListeners();
        return order;
      } else {
        _setError('Failed to save order: ${result['error']}');
        return null;
      }
    } catch (e) {
      _setError('Failed to create order: $e');
      return null;
    } finally {
      _setProcessingOrder(false);
    }
  }

  /// Load orders
  Future<void> _loadOrders() async {
    try {
      // Load from Firestore with error handling
      final result = await _firestoreService.getCollection(
        collection: 'orders',
      );

      if (result['success'] == true && result['data'] != null) {
        final List<Map<String, dynamic>> orderDocs =
            List<Map<String, dynamic>>.from(result['data']);
        _orders = orderDocs.map((doc) => OrderModel.fromJson(doc)).toList();
        _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        // Fallback to mock data if Firestore fails
        _orders = _generateMockOrders();
      }

      _updateRecentOrders();
      notifyListeners();
    } catch (e) {
      // Fallback to mock data on any error
      _orders = _generateMockOrders();
      _updateRecentOrders();
      notifyListeners();
    }
  }

  /// Load payment methods
  Future<void> _loadPaymentMethods() async {
    try {
      // Load from Firestore (implementation)
      _paymentMethods = _generateMockPaymentMethods();

      if (_paymentMethods.isNotEmpty) {
        _selectedPaymentMethod = _paymentMethods.first;
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load payment methods: $e');
    }
  }

  /// Load cart from storage
  Future<void> _loadCart() async {
    try {
      // Load from SharedPreferences or secure storage (implementation)
      // For now, start with empty cart
      _cartItems = [];
      _calculateCartTotals();
    } catch (e) {
      // Handle error silently
    }
  }

  /// Save cart to storage
  Future<void> _saveCart() async {
    try {
      // Save to SharedPreferences or secure storage (implementation)
    } catch (e) {
      // Handle error silently
    }
  }

  /// Update recent orders
  void _updateRecentOrders() {
    _recentOrders = _orders.take(5).toList();
  }

  /// Set order status filter
  void setOrderStatusFilter(String status) {
    _orderStatusFilter = status;
    notifyListeners();
  }

  /// Set order date filter
  void setOrderDateFilter(DateTime? date) {
    _orderDateFilter = date;
    notifyListeners();
  }

  /// Clear filters
  void clearFilters() {
    _orderStatusFilter = 'all';
    _orderDateFilter = null;
    notifyListeners();
  }

  /// Select order
  void selectOrder(OrderModel order) {
    _selectedOrder = order;
    notifyListeners();
  }

  /// Set selected payment method
  void setSelectedPaymentMethod(payment.PaymentMethod paymentMethod) {
    _selectedPaymentMethod = paymentMethod;
    notifyListeners();
  }

  /// Update order status (admin function)
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final orderIndex = _orders.indexWhere((o) => o.id == orderId);
      if (orderIndex != -1) {
        final updatedOrder = _orders[orderIndex].copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );

        // Update in Firestore first
        final result = await _firestoreService.updateDocument(
          collection: 'orders',
          documentId: orderId,
          data: updatedOrder.toJson(),
        );

        if (result['success'] == true) {
          // Update local state only if Firestore update succeeded
          _orders[orderIndex] = updatedOrder;
          notifyListeners();
        } else {
          _setError('Failed to update order status: ${result['error']}');
        }
      }
    } catch (e) {
      _setError('Failed to update order status: $e');
    }
  }

  /// Generate mock orders
  List<OrderModel> _generateMockOrders() {
    final now = DateTime.now();
    return [
      OrderModel(
        id: 'ORD-001',
        userId: 'user1',
        items: [
          cart.CartItem(
            id: '1',
            productId: 'laptop-1',
            productName: 'Business Laptop Pro',
            price: 1299.99,
            quantity: 1,
            addedAt: now,
          ),
        ],
        subtotal: 1299.99,
        tax: 65.0,
        shippingCost: 0.0,
        discountAmount: 0.0,
        total: 1364.99,
        status: 'delivered',
        paymentMethod: const payment.PaymentMethod(
          id: '1',
          type: 'credit_card',
          displayName: '**** 1234',
          isDefault: true,
        ),
        shippingAddress: '123 Business St, Dubai, UAE',
        billingAddress: '123 Business St, Dubai, UAE',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      OrderModel(
        id: 'ORD-002',
        userId: 'user1',
        items: [
          cart.CartItem(
            id: '2',
            productId: 'software-1',
            productName: 'Office Suite Premium',
            price: 199.99,
            quantity: 1,
            addedAt: now,
          ),
        ],
        subtotal: 199.99,
        tax: 10.0,
        shippingCost: 0.0,
        discountAmount: 0.0,
        total: 209.99,
        status: 'processing',
        paymentMethod: const payment.PaymentMethod(
          id: '1',
          type: 'credit_card',
          displayName: '**** 1234',
          isDefault: true,
        ),
        shippingAddress: '123 Business St, Dubai, UAE',
        billingAddress: '123 Business St, Dubai, UAE',
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
    ];
  }

  /// Generate mock payment methods
  List<payment.PaymentMethod> _generateMockPaymentMethods() {
    return [
      const payment.PaymentMethod(
        id: '1',
        type: 'credit_card',
        displayName: 'Visa **** 1234',
        isDefault: true,
        cardBrand: 'visa',
        lastFour: '1234',
        expiryMonth: 12,
        expiryYear: 2026,
      ),
      const payment.PaymentMethod(
        id: '2',
        type: 'digital_wallet',
        displayName: 'Apple Pay',
        isDefault: false,
      ),
      const payment.PaymentMethod(
        id: '3',
        type: 'bank_transfer',
        displayName: 'Bank Transfer',
        isDefault: false,
      ),
    ];
  }

  /// Helper function to compare maps
  bool _mapEquals(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    return true;
  }

  /// Refresh all data
  Future<void> refresh() async {
    await _loadOrders();
  }

  /// Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setProcessingOrder(bool processing) {
    _isProcessingOrder = processing;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    _cartItems.clear();
    _orders.clear();
    _recentOrders.clear();
    _paymentMethods.clear();
    super.dispose();
  }
}
