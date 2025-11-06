/// Invoice model for MultiSales app
class Invoice {
  final String id;
  final String userId;
  final String invoiceNumber;
  final double amount;
  final double taxAmount;
  final double totalAmount;
  final String currency;
  final String status; // pending, paid, overdue, cancelled
  final DateTime issueDate;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String? paymentMethod;
  final String? transactionId;
  final List<InvoiceItem> items;
  final Map<String, dynamic> billingAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Invoice({
    required this.id,
    required this.userId,
    required this.invoiceNumber,
    required this.amount,
    required this.taxAmount,
    required this.totalAmount,
    this.currency = 'USD',
    required this.status,
    required this.issueDate,
    required this.dueDate,
    this.paidDate,
    this.paymentMethod,
    this.transactionId,
    this.items = const [],
    this.billingAddress = const {},
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create Invoice from Firestore document
  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      invoiceNumber: map['invoiceNumber'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      taxAmount: (map['taxAmount'] ?? 0.0).toDouble(),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'USD',
      status: map['status'] ?? 'pending',
      issueDate: DateTime.fromMillisecondsSinceEpoch(
        map['issueDate']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
      dueDate: DateTime.fromMillisecondsSinceEpoch(
        map['dueDate']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
      paidDate: map['paidDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['paidDate'].millisecondsSinceEpoch)
          : null,
      paymentMethod: map['paymentMethod'],
      transactionId: map['transactionId'],
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => InvoiceItem.fromMap(item))
              .toList() ??
          [],
      billingAddress: Map<String, dynamic>.from(map['billingAddress'] ?? {}),
      notes: map['notes'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// Convert Invoice to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'invoiceNumber': invoiceNumber,
      'amount': amount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'currency': currency,
      'status': status,
      'issueDate': issueDate,
      'dueDate': dueDate,
      'paidDate': paidDate,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'items': items.map((item) => item.toMap()).toList(),
      'billingAddress': billingAddress,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Check if invoice is pending payment
  bool get isPending => status.toLowerCase() == 'pending';

  /// Check if invoice is paid
  bool get isPaid => status.toLowerCase() == 'paid';

  /// Check if invoice is overdue
  bool get isOverdue {
    if (isPaid) return false;
    return DateTime.now().isAfter(dueDate);
  }

  /// Get days until due (negative if overdue)
  int get daysToDue {
    final difference = dueDate.difference(DateTime.now());
    return difference.inDays;
  }

  /// Get formatted invoice number
  String get formattedInvoiceNumber {
    return 'INV-$invoiceNumber';
  }

  /// Create a copy with updated fields
  Invoice copyWith({
    String? id,
    String? userId,
    String? invoiceNumber,
    double? amount,
    double? taxAmount,
    double? totalAmount,
    String? currency,
    String? status,
    DateTime? issueDate,
    DateTime? dueDate,
    DateTime? paidDate,
    String? paymentMethod,
    String? transactionId,
    List<InvoiceItem>? items,
    Map<String, dynamic>? billingAddress,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      amount: amount ?? this.amount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      items: items ?? this.items,
      billingAddress: billingAddress ?? this.billingAddress,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Invoice(id: $id, invoiceNumber: $invoiceNumber, status: $status, amount: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Invoice && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Invoice item model
class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? serviceId;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.serviceId,
  });

  /// Create InvoiceItem from map
  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? 1,
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      serviceId: map['serviceId'],
    );
  }

  /// Convert InvoiceItem to map
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'serviceId': serviceId,
    };
  }

  @override
  String toString() {
    return 'InvoiceItem(description: $description, quantity: $quantity, totalPrice: $totalPrice)';
  }
}
