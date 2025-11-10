/// Represents an order in the system
class Order {
  final String id;
  final String supplierId;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? notes;

  Order({
    required this.id,
    required this.supplierId,
    required this.items,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    this.notes,
  });

  /// Calculate the total amount of the order
  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Create a copy of the order with updated fields
  Order copyWith({
    String? id,
    String? supplierId,
    List<OrderItem>? items,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      items: items ?? this.items,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, supplier: $supplierId, items: ${items.length}, status: $status, total: €${totalAmount.toStringAsFixed(2)})';
  }

  /// Convert Order to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierId': supplierId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.name,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'notes': notes,
    };
  }

  /// Create Order from JSON (Firebase)
  factory Order.fromJson(Map<dynamic, dynamic> json) {
    return Order(
      id: json['id'] as String,
      supplierId: json['supplierId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<dynamic, dynamic>))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderDate: DateTime.parse(json['orderDate'] as String),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'] as String)
          : null,
      notes: json['notes'] as String?,
    );
  }
}

/// Represents an item in an order
class OrderItem {
  final String productId;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  /// Calculate the total price for this item
  double get totalPrice => quantity * unitPrice;

  @override
  String toString() {
    return 'OrderItem(productId: $productId, quantity: $quantity, unitPrice: €$unitPrice, total: €${totalPrice.toStringAsFixed(2)})';
  }

  /// Convert OrderItem to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  /// Create OrderItem from JSON (Firebase)
  factory OrderItem.fromJson(Map<dynamic, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );
  }
}

/// Status of an order
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}
