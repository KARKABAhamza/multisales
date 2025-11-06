import 'cart_item.dart';
import 'payment_method.dart';

/// Order model for MultiSales app e-commerce system
class OrderModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double discountAmount;
  final double total;
  final String
      status; // pending, processing, shipped, delivered, cancelled, refunded
  final PaymentMethod paymentMethod;
  final String shippingAddress;
  final String billingAddress;
  final String? specialInstructions;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? promoCode;
  final Map<String, dynamic> metadata;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.discountAmount,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.billingAddress,
    this.specialInstructions,
    this.trackingNumber,
    this.estimatedDelivery,
    required this.createdAt,
    required this.updatedAt,
    this.promoCode,
    this.metadata = const {},
  });

  /// Create copy with updated fields
  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? subtotal,
    double? tax,
    double? shippingCost,
    double? discountAmount,
    double? total,
    String? status,
    PaymentMethod? paymentMethod,
    String? shippingAddress,
    String? billingAddress,
    String? specialInstructions,
    String? trackingNumber,
    DateTime? estimatedDelivery,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? promoCode,
    Map<String, dynamic>? metadata,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      shippingCost: shippingCost ?? this.shippingCost,
      discountAmount: discountAmount ?? this.discountAmount,
      total: total ?? this.total,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      promoCode: promoCode ?? this.promoCode,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shippingCost': shippingCost,
      'discountAmount': discountAmount,
      'total': total,
      'status': status,
      'paymentMethod': paymentMethod.toJson(),
      'shippingAddress': shippingAddress,
      'billingAddress': billingAddress,
      'specialInstructions': specialInstructions,
      'trackingNumber': trackingNumber,
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'promoCode': promoCode,
      'metadata': metadata,
    };
  }

  /// Create from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      shippingCost: (json['shippingCost'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      paymentMethod:
          PaymentMethod.fromJson(json['paymentMethod'] as Map<String, dynamic>),
      shippingAddress: json['shippingAddress'] as String,
      billingAddress: json['billingAddress'] as String,
      specialInstructions: json['specialInstructions'] as String?,
      trackingNumber: json['trackingNumber'] as String?,
      estimatedDelivery: json['estimatedDelivery'] != null
          ? DateTime.parse(json['estimatedDelivery'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      promoCode: json['promoCode'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Business logic methods
  bool get isPending => status == 'pending';
  bool get isProcessing => status == 'processing';
  bool get isShipped => status == 'shipped';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
  bool get isRefunded => status == 'refunded';

  bool get canBeCancelled => isPending || isProcessing;
  bool get canBeRefunded => isDelivered;
  bool get hasTracking => trackingNumber != null && trackingNumber!.isNotEmpty;

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get formattedOrderNumber => 'MultiSales-${id.substring(4)}';

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Pending Payment';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'refunded':
        return 'Refunded';
      default:
        return status.toUpperCase();
    }
  }

  String get estimatedDeliveryText {
    if (estimatedDelivery == null) return 'Not available';

    final now = DateTime.now();
    final difference = estimatedDelivery!.difference(now).inDays;

    if (difference < 0) {
      return 'Overdue by ${-difference} days';
    } else if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else {
      return 'In $difference days';
    }
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, status: $status, total: \$${total.toStringAsFixed(2)}, items: ${items.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
