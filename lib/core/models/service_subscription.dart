/// Service subscription model for MultiSales app
class ServiceSubscription {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final String serviceCategory;
  final double monthlyPrice;
  final String billingCycle; // monthly, quarterly, yearly
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final bool autoRenewal;
  final Map<String, dynamic> features;
  final String status; // active, suspended, cancelled, expired
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceSubscription({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.serviceCategory,
    required this.monthlyPrice,
    required this.billingCycle,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.autoRenewal = true,
    this.features = const {},
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create ServiceSubscription from Firestore document
  factory ServiceSubscription.fromMap(Map<String, dynamic> map) {
    return ServiceSubscription(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      serviceId: map['serviceId'] ?? '',
      serviceName: map['serviceName'] ?? '',
      serviceCategory: map['serviceCategory'] ?? '',
      monthlyPrice: (map['monthlyPrice'] ?? 0.0).toDouble(),
      billingCycle: map['billingCycle'] ?? 'monthly',
      startDate: DateTime.fromMillisecondsSinceEpoch(
        map['startDate']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'].millisecondsSinceEpoch)
          : null,
      isActive: map['isActive'] ?? true,
      autoRenewal: map['autoRenewal'] ?? true,
      features: Map<String, dynamic>.from(map['features'] ?? {}),
      status: map['status'] ?? 'active',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// Convert ServiceSubscription to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceCategory': serviceCategory,
      'monthlyPrice': monthlyPrice,
      'billingCycle': billingCycle,
      'startDate': startDate,
      'endDate': endDate,
      'isActive': isActive,
      'autoRenewal': autoRenewal,
      'features': features,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Check if subscription is currently active
  bool get isCurrentlyActive {
    if (!isActive) return false;
    if (status != 'active') return false;
    if (endDate != null && DateTime.now().isAfter(endDate!)) return false;
    return true;
  }

  /// Get days remaining until expiration
  int? get daysRemaining {
    if (endDate == null) return null;
    final difference = endDate!.difference(DateTime.now());
    return difference.inDays;
  }

  /// Calculate total price based on billing cycle
  double get totalPrice {
    switch (billingCycle.toLowerCase()) {
      case 'quarterly':
        return monthlyPrice * 3;
      case 'yearly':
        return monthlyPrice * 12;
      default:
        return monthlyPrice;
    }
  }

  /// Create a copy with updated fields
  ServiceSubscription copyWith({
    String? id,
    String? userId,
    String? serviceId,
    String? serviceName,
    String? serviceCategory,
    double? monthlyPrice,
    String? billingCycle,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    bool? autoRenewal,
    Map<String, dynamic>? features,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceSubscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      billingCycle: billingCycle ?? this.billingCycle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      autoRenewal: autoRenewal ?? this.autoRenewal,
      features: features ?? this.features,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ServiceSubscription(id: $id, serviceName: $serviceName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceSubscription && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
