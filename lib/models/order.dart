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
