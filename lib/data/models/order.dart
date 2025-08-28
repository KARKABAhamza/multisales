import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final Address shippingAddress;
  final Address? billingAddress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final String? trackingNumber;
  final String? notes;
  final List<OrderStatusUpdate> statusHistory;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.shippingAddress,
    this.billingAddress,
    required this.createdAt,
    required this.updatedAt,
    this.shippedAt,
    this.deliveredAt,
    this.trackingNumber,
    this.notes,
    this.statusHistory = const [],
  });

  // Factory constructor for creating Order from Firestore document
  factory Order.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Order(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      subtotal: (data['subtotal'] ?? 0.0).toDouble(),
      tax: (data['tax'] ?? 0.0).toDouble(),
      shipping: (data['shipping'] ?? 0.0).toDouble(),
      total: (data['total'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (p) => p.name == data['paymentMethod'],
        orElse: () => PaymentMethod.creditCard,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (p) => p.name == data['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      shippingAddress: Address.fromMap(
          data['shippingAddress'] as Map<String, dynamic>? ?? {}),
      billingAddress: data['billingAddress'] != null
          ? Address.fromMap(data['billingAddress'] as Map<String, dynamic>)
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      shippedAt: (data['shippedAt'] as Timestamp?)?.toDate(),
      deliveredAt: (data['deliveredAt'] as Timestamp?)?.toDate(),
      trackingNumber: data['trackingNumber'],
      notes: data['notes'],
      statusHistory: (data['statusHistory'] as List<dynamic>? ?? [])
          .map((update) =>
              OrderStatusUpdate.fromMap(update as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert Order to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'total': total,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'paymentStatus': paymentStatus.name,
      'shippingAddress': shippingAddress.toMap(),
      'billingAddress': billingAddress?.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'shippedAt': shippedAt != null ? Timestamp.fromDate(shippedAt!) : null,
      'deliveredAt':
          deliveredAt != null ? Timestamp.fromDate(deliveredAt!) : null,
      'trackingNumber': trackingNumber,
      'notes': notes,
      'statusHistory': statusHistory.map((update) => update.toMap()).toList(),
    };
  }

  // Get order number (formatted ID)
  String get orderNumber => 'MS-${id.substring(0, 8).toUpperCase()}';

  // Check if order is cancellable
  bool get canBeCancelled =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  // Check if order is trackable
  bool get isTrackable => trackingNumber != null && trackingNumber!.isNotEmpty;

  // Get estimated delivery date
  DateTime? get estimatedDelivery {
    if (shippedAt == null) return null;
    return shippedAt!.add(const Duration(days: 3)); // Default 3-day delivery
  }

  @override
  String toString() {
    return 'Order(id: $id, total: $total, status: $status)';
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productSku;
  final String productImageUrl;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final Map<String, dynamic> selectedOptions;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.productImageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.selectedOptions = const {},
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productSku: map['productSku'] ?? '',
      productImageUrl: map['productImageUrl'] ?? '',
      quantity: map['quantity'] ?? 1,
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      selectedOptions: Map<String, dynamic>.from(map['selectedOptions'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productSku': productSku,
      'productImageUrl': productImageUrl,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'selectedOptions': selectedOptions,
    };
  }

  // Create OrderItem from Product
  factory OrderItem.fromProduct(Product product, int quantity) {
    final totalPrice = product.effectivePrice * quantity;
    return OrderItem(
      productId: product.id,
      productName: product.name,
      productSku: product.sku,
      productImageUrl: product.primaryImageUrl,
      quantity: quantity,
      unitPrice: product.effectivePrice,
      totalPrice: totalPrice,
    );
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? apartment;
  final String? company;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.apartment,
    this.company,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      country: map['country'] ?? '',
      apartment: map['apartment'],
      company: map['company'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'apartment': apartment,
      'company': company,
    };
  }

  String get fullAddress {
    final parts = <String>[
      if (company != null && company!.isNotEmpty) company!,
      street,
      if (apartment != null && apartment!.isNotEmpty) apartment!,
      city,
      '$state $zipCode',
      country,
    ];
    return parts.join(', ');
  }
}

class OrderStatusUpdate {
  final OrderStatus status;
  final DateTime timestamp;
  final String? notes;
  final String? updatedBy;

  OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    this.notes,
    this.updatedBy,
  });

  factory OrderStatusUpdate.fromMap(Map<String, dynamic> map) {
    return OrderStatusUpdate(
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: map['notes'],
      updatedBy: map['updatedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'notes': notes,
      'updatedBy': updatedBy,
    };
  }
}

// Order status enum
enum OrderStatus {
  pending('Pending', 'Order received and being processed'),
  confirmed('Confirmed', 'Order confirmed and being prepared'),
  processing('Processing', 'Order is being prepared for shipment'),
  shipped('Shipped', 'Order has been shipped'),
  delivered('Delivered', 'Order has been delivered'),
  cancelled('Cancelled', 'Order has been cancelled'),
  returned('Returned', 'Order has been returned'),
  refunded('Refunded', 'Order has been refunded');

  const OrderStatus(this.displayName, this.description);
  final String displayName;
  final String description;
}

// Payment method enum
enum PaymentMethod {
  creditCard('Credit Card'),
  debitCard('Debit Card'),
  paypal('PayPal'),
  bankTransfer('Bank Transfer'),
  cashOnDelivery('Cash on Delivery'),
  applePay('Apple Pay'),
  googlePay('Google Pay');

  const PaymentMethod(this.displayName);
  final String displayName;
}

// Payment status enum
enum PaymentStatus {
  pending('Pending'),
  paid('Paid'),
  failed('Failed'),
  refunded('Refunded'),
  partiallyRefunded('Partially Refunded');

  const PaymentStatus(this.displayName);
  final String displayName;
}
