import 'package:flutter/foundation.dart';

@immutable
class OrderItem {
  final String productId;
  final int qty;
  final double unitPrice;

  const OrderItem({required this.productId, required this.qty, required this.unitPrice});

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json['productId'] as String,
        qty: (json['qty'] as num).toInt(),
        unitPrice: (json['unitPrice'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'qty': qty,
        'unitPrice': unitPrice,
      };
}

@immutable
class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime? createdAt;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        userId: json['userId'] as String,
        items: (json['items'] as List<dynamic>).map((e) => OrderItem.fromJson(Map<String, dynamic>.from(e))).toList(),
        total: (json['total'] as num).toDouble(),
        status: json['status'] as String,
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
      };
}