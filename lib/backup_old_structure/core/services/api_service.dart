import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Comprehensive API service for handling all backend operations
class ApiService {
  static const String _baseUrl = 'https://api.multisales.com/v1';
  static const String _wsUrl = 'wss://ws.multisales.com/v1';

  late String _authToken;
  Timer? _tokenRefreshTimer;
  StreamController<Map<String, dynamic>>? _realtimeController;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Initialize the API service with authentication token
  void initialize(String authToken) {
    _authToken = authToken;
    _startTokenRefresh();
    _initializeRealtime();
  }

  /// Common headers for all requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
        'X-Client-Version': '1.0.0',
        'X-Platform': defaultTargetPlatform.name,
      };

  // AUTHENTICATION ENDPOINTS

  /// Register a new user
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required String businessType,
    String? companyName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'role': role,
          'businessType': businessType,
          if (companyName != null) 'companyName': companyName,
        }),
      );

      final data = _handleResponse(response);
      return AuthResponse.fromJson(data);
    } catch (e) {
      throw ApiException('Registration failed: ${e.toString()}');
    }
  }

  /// Sign in existing user
  Future<AuthResponse> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'rememberMe': rememberMe,
        }),
      );

      final data = _handleResponse(response);
      final authResponse = AuthResponse.fromJson(data);

      // Initialize with new token
      initialize(authResponse.accessToken);

      return authResponse;
    } catch (e) {
      throw ApiException('Sign in failed: ${e.toString()}');
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/auth/signout'),
        headers: _headers,
      );
    } finally {
      _cleanup();
    }
  }

  /// Refresh authentication token
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      final data = _handleResponse(response);
      final newToken = data['accessToken'] as String;
      _authToken = newToken;

      return newToken;
    } catch (e) {
      throw ApiException('Token refresh failed: ${e.toString()}');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      _handleResponse(response);
    } catch (e) {
      throw ApiException('Password reset failed: ${e.toString()}');
    }
  }

  // USER PROFILE ENDPOINTS

  /// Get current user profile
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/profile'),
        headers: _headers,
      );

      final data = _handleResponse(response);
      return UserProfile.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to fetch user profile: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<UserProfile> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/user/profile'),
        headers: _headers,
        body: jsonEncode(updates),
      );

      final data = _handleResponse(response);
      return UserProfile.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to update profile: ${e.toString()}');
    }
  }

  /// Upload profile picture
  Future<String> uploadProfilePicture(
      List<int> imageBytes, String fileName) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/user/profile/picture'),
      );

      request.headers.addAll(_headers);
      request.files.add(
        http.MultipartFile.fromBytes(
          'picture',
          imageBytes,
          filename: fileName,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = _handleResponse(response);
      return data['imageUrl'] as String;
    } catch (e) {
      throw ApiException('Failed to upload profile picture: ${e.toString()}');
    }
  }

  // PRODUCT ENDPOINTS

  /// Get products with filtering and pagination
  Future<ProductResponse> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'category': category,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
      };

      final uri = Uri.parse('$_baseUrl/products').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: _headers);
      final data = _handleResponse(response);

      return ProductResponse.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to fetch products: ${e.toString()}');
    }
  }

  /// Get single product by ID
  Future<ProductDetail> getProduct(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/$productId'),
        headers: _headers,
      );

      final data = _handleResponse(response);
      return ProductDetail.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to fetch product: ${e.toString()}');
    }
  }

  /// Create new product
  Future<ProductDetail> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/products'),
        headers: _headers,
        body: jsonEncode(productData),
      );

      final data = _handleResponse(response);
      return ProductDetail.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to create product: ${e.toString()}');
    }
  }

  /// Update product
  Future<ProductDetail> updateProduct(
      String productId, Map<String, dynamic> updates) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/products/$productId'),
        headers: _headers,
        body: jsonEncode(updates),
      );

      final data = _handleResponse(response);
      return ProductDetail.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to update product: ${e.toString()}');
    }
  }

  // ORDER ENDPOINTS

  /// Get orders with filtering
  Future<OrderResponse> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      };

      final uri = Uri.parse('$_baseUrl/orders').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: _headers);
      final data = _handleResponse(response);

      return OrderResponse.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to fetch orders: ${e.toString()}');
    }
  }

  /// Get single order by ID
  Future<OrderDetail> getOrder(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/orders/$orderId'),
        headers: _headers,
      );

      final data = _handleResponse(response);
      return OrderDetail.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to fetch order: ${e.toString()}');
    }
  }

  /// Create new order
  Future<OrderDetail> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/orders'),
        headers: _headers,
        body: jsonEncode(orderData),
      );

      final data = _handleResponse(response);
      return OrderDetail.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to create order: ${e.toString()}');
    }
  }

  /// Update order status
  Future<OrderDetail> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/orders/$orderId/status'),
        headers: _headers,
        body: jsonEncode({'status': status}),
      );

      final data = _handleResponse(response);
      return OrderDetail.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to update order status: ${e.toString()}');
    }
  }

  // ANALYTICS ENDPOINTS

  /// Get dashboard analytics
  Future<DashboardAnalytics> getDashboardAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, String>{
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      };

      final uri = Uri.parse('$_baseUrl/analytics/dashboard').replace(
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final response = await http.get(uri, headers: _headers);
      final data = _handleResponse(response);

      return DashboardAnalytics.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to fetch analytics: ${e.toString()}');
    }
  }

  /// Get sales report
  Future<SalesReport> getSalesReport({
    required DateTime startDate,
    required DateTime endDate,
    String groupBy = 'day',
  }) async {
    try {
      final queryParams = {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'groupBy': groupBy,
      };

      final uri = Uri.parse('$_baseUrl/analytics/sales').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: _headers);
      final data = _handleResponse(response);

      return SalesReport.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to fetch sales report: ${e.toString()}');
    }
  }

  // SUPPORT ENDPOINTS

  /// Get support tickets
  Future<SupportTicketResponse> getSupportTickets({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
      };

      final uri = Uri.parse('$_baseUrl/support/tickets').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: _headers);
      final data = _handleResponse(response);

      return SupportTicketResponse.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to fetch support tickets: ${e.toString()}');
    }
  }

  /// Create support ticket
  Future<SupportTicketDetail> createSupportTicket({
    required String subject,
    required String description,
    required String category,
    String priority = 'medium',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/support/tickets'),
        headers: _headers,
        body: jsonEncode({
          'subject': subject,
          'description': description,
          'category': category,
          'priority': priority,
        }),
      );

      final data = _handleResponse(response);
      return SupportTicketDetail.fromJson(data);
    } catch (e) {
      throw ApiException('Failed to create support ticket: ${e.toString()}');
    }
  }

  // REAL-TIME FEATURES

  /// Initialize real-time connection
  void _initializeRealtime() {
    _realtimeController = StreamController<Map<String, dynamic>>.broadcast();
    // In a real implementation, this would connect to WebSocket at $_wsUrl
    // For now, we'll simulate with periodic updates
    if (kDebugMode) {
      print('WebSocket connection would be established at $_wsUrl');
    }
  }

  /// Get real-time updates stream
  Stream<Map<String, dynamic>>? get realtimeUpdates =>
      _realtimeController?.stream;

  /// Subscribe to real-time notifications
  void subscribeToNotifications() {
    // Implementation would connect to WebSocket for real-time notifications
    Timer.periodic(const Duration(seconds: 30), (timer) {
      _realtimeController?.add({
        'type': 'notification',
        'data': {
          'message': 'You have new orders to review',
          'timestamp': DateTime.now().toIso8601String(),
        },
      });
    });
  }

  // THIRD-PARTY INTEGRATIONS

  /// Google Maps integration
  Future<List<MapLocation>> searchLocations(String query) async {
    try {
      // In real implementation, this would call Google Places API
      final mockLocations = [
        MapLocation(
          id: '1',
          name: 'Business Location 1',
          address: '123 Main St, City, State',
          latitude: 40.7128,
          longitude: -74.0060,
        ),
        MapLocation(
          id: '2',
          name: 'Business Location 2',
          address: '456 Oak Ave, City, State',
          latitude: 40.7589,
          longitude: -73.9851,
        ),
      ];

      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate API call
      return mockLocations;
    } catch (e) {
      throw ApiException('Failed to search locations: ${e.toString()}');
    }
  }

  /// Stripe payment integration
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required String paymentMethodId,
  }) async {
    try {
      // In real implementation, this would integrate with Stripe
      await Future.delayed(const Duration(seconds: 2)); // Simulate processing

      return PaymentResult(
        success: true,
        transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        amount: amount,
        currency: currency,
      );
    } catch (e) {
      throw ApiException('Payment processing failed: ${e.toString()}');
    }
  }

  // UTILITY METHODS

  /// Handle HTTP response and extract data
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final errorData = jsonDecode(response.body) as Map<String, dynamic>;
      throw ApiException(
        errorData['message'] as String? ?? 'Unknown error occurred',
        statusCode: response.statusCode,
      );
    }
  }

  /// Start automatic token refresh
  void _startTokenRefresh() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      // In real implementation, check if token needs refresh
    });
  }

  /// Cleanup resources
  void _cleanup() {
    _tokenRefreshTimer?.cancel();
    _realtimeController?.close();
  }
}

// DATA MODELS

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserProfile user;
  final DateTime expiresAt;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: UserProfile.fromJson(json['user']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}

class UserProfile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePictureUrl;
  final String role;
  final String businessType;
  final String? companyName;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePictureUrl,
    required this.role,
    required this.businessType,
    this.companyName,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePictureUrl: json['profilePictureUrl'],
      role: json['role'],
      businessType: json['businessType'],
      companyName: json['companyName'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  String get fullName => '$firstName $lastName';
}

class ProductResponse {
  final List<ProductSummary> products;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  ProductResponse({
    required this.products,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: (json['products'] as List)
          .map((p) => ProductSummary.fromJson(p))
          .toList(),
      totalCount: json['totalCount'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}

class ProductSummary {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final bool inStock;
  final double rating;
  final int reviewCount;

  ProductSummary({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.inStock,
    required this.rating,
    required this.reviewCount,
  });

  factory ProductSummary.fromJson(Map<String, dynamic> json) {
    return ProductSummary(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      inStock: json['inStock'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
    );
  }
}

class ProductDetail extends ProductSummary {
  final String description;
  final String category;
  final List<String> imageUrls;
  final Map<String, dynamic> specifications;
  final DateTime createdAt;

  ProductDetail({
    required super.id,
    required super.name,
    required super.price,
    super.imageUrl,
    required super.inStock,
    required super.rating,
    required super.reviewCount,
    required this.description,
    required this.category,
    required this.imageUrls,
    required this.specifications,
    required this.createdAt,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      inStock: json['inStock'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      description: json['description'],
      category: json['category'],
      imageUrls: List<String>.from(json['imageUrls']),
      specifications: json['specifications'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class OrderResponse {
  final List<OrderSummary> orders;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  OrderResponse({
    required this.orders,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orders: (json['orders'] as List)
          .map((o) => OrderSummary.fromJson(o))
          .toList(),
      totalCount: json['totalCount'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}

class OrderSummary {
  final String id;
  final String orderNumber;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final int itemCount;

  OrderSummary({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.itemCount,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      id: json['id'],
      orderNumber: json['orderNumber'],
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      itemCount: json['itemCount'],
    );
  }
}

class OrderDetail extends OrderSummary {
  final List<OrderItem> items;
  final Map<String, dynamic> shippingAddress;
  final Map<String, dynamic> billingAddress;
  final String? trackingNumber;

  OrderDetail({
    required super.id,
    required super.orderNumber,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
    required super.itemCount,
    required this.items,
    required this.shippingAddress,
    required this.billingAddress,
    this.trackingNumber,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      orderNumber: json['orderNumber'],
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      itemCount: json['itemCount'],
      items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
      shippingAddress: json['shippingAddress'],
      billingAddress: json['billingAddress'],
      trackingNumber: json['trackingNumber'],
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
    );
  }
}

class DashboardAnalytics {
  final double totalSales;
  final int totalOrders;
  final int totalCustomers;
  final int totalProducts;
  final double salesGrowth;
  final double orderGrowth;
  final List<ChartDataPoint> salesChart;

  DashboardAnalytics({
    required this.totalSales,
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalProducts,
    required this.salesGrowth,
    required this.orderGrowth,
    required this.salesChart,
  });

  factory DashboardAnalytics.fromJson(Map<String, dynamic> json) {
    return DashboardAnalytics(
      totalSales: json['totalSales'].toDouble(),
      totalOrders: json['totalOrders'],
      totalCustomers: json['totalCustomers'],
      totalProducts: json['totalProducts'],
      salesGrowth: json['salesGrowth'].toDouble(),
      orderGrowth: json['orderGrowth'].toDouble(),
      salesChart: (json['salesChart'] as List)
          .map((c) => ChartDataPoint.fromJson(c))
          .toList(),
    );
  }
}

class ChartDataPoint {
  final DateTime date;
  final double value;

  ChartDataPoint({
    required this.date,
    required this.value,
  });

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartDataPoint(
      date: DateTime.parse(json['date']),
      value: json['value'].toDouble(),
    );
  }
}

class SalesReport {
  final List<ChartDataPoint> dailySales;
  final Map<String, double> topProducts;
  final Map<String, double> salesByCategory;

  SalesReport({
    required this.dailySales,
    required this.topProducts,
    required this.salesByCategory,
  });

  factory SalesReport.fromJson(Map<String, dynamic> json) {
    return SalesReport(
      dailySales: (json['dailySales'] as List)
          .map((d) => ChartDataPoint.fromJson(d))
          .toList(),
      topProducts: Map<String, double>.from(json['topProducts']),
      salesByCategory: Map<String, double>.from(json['salesByCategory']),
    );
  }
}

class SupportTicketResponse {
  final List<SupportTicketSummary> tickets;
  final int totalCount;

  SupportTicketResponse({
    required this.tickets,
    required this.totalCount,
  });

  factory SupportTicketResponse.fromJson(Map<String, dynamic> json) {
    return SupportTicketResponse(
      tickets: (json['tickets'] as List)
          .map((t) => SupportTicketSummary.fromJson(t))
          .toList(),
      totalCount: json['totalCount'],
    );
  }
}

class SupportTicketSummary {
  final String id;
  final String subject;
  final String status;
  final String priority;
  final DateTime createdAt;

  SupportTicketSummary({
    required this.id,
    required this.subject,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  factory SupportTicketSummary.fromJson(Map<String, dynamic> json) {
    return SupportTicketSummary(
      id: json['id'],
      subject: json['subject'],
      status: json['status'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class SupportTicketDetail extends SupportTicketSummary {
  final String description;
  final String category;
  final String? assignedAgent;
  final List<TicketMessage> messages;

  SupportTicketDetail({
    required super.id,
    required super.subject,
    required super.status,
    required super.priority,
    required super.createdAt,
    required this.description,
    required this.category,
    this.assignedAgent,
    required this.messages,
  });

  factory SupportTicketDetail.fromJson(Map<String, dynamic> json) {
    return SupportTicketDetail(
      id: json['id'],
      subject: json['subject'],
      status: json['status'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['createdAt']),
      description: json['description'],
      category: json['category'],
      assignedAgent: json['assignedAgent'],
      messages: (json['messages'] as List)
          .map((m) => TicketMessage.fromJson(m))
          .toList(),
    );
  }
}

class TicketMessage {
  final String id;
  final String message;
  final bool isFromSupport;
  final DateTime timestamp;

  TicketMessage({
    required this.id,
    required this.message,
    required this.isFromSupport,
    required this.timestamp,
  });

  factory TicketMessage.fromJson(Map<String, dynamic> json) {
    return TicketMessage(
      id: json['id'],
      message: json['message'],
      isFromSupport: json['isFromSupport'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class MapLocation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  MapLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class PaymentResult {
  final bool success;
  final String? transactionId;
  final double amount;
  final String currency;
  final String? errorMessage;

  PaymentResult({
    required this.success,
    this.transactionId,
    required this.amount,
    required this.currency,
    this.errorMessage,
  });
}

// EXCEPTIONS

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}
