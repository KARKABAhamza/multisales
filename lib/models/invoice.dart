/// Represents an invoice in the system
class Invoice {
  final String id;
  final String orderId;
  final DateTime issueDate;
  final DateTime dueDate;
  final double amount;
  final InvoiceStatus status;
  final String? notes;
  final double? taxAmount;
  final double? discountAmount;

  Invoice({
    required this.id,
    required this.orderId,
    required this.issueDate,
    required this.dueDate,
    required this.amount,
    required this.status,
    this.notes,
    this.taxAmount,
    this.discountAmount,
  });

  /// Calculate the total amount including tax and discount
  double get totalAmount {
    double total = amount;
    if (taxAmount != null) {
      total += taxAmount!;
    }
    if (discountAmount != null) {
      total -= discountAmount!;
    }
    return total;
  }

  /// Check if the invoice is overdue
  bool get isOverdue {
    return status == InvoiceStatus.issued && DateTime.now().isAfter(dueDate);
  }

  /// Create a copy of the invoice with updated fields
  Invoice copyWith({
    String? id,
    String? orderId,
    DateTime? issueDate,
    DateTime? dueDate,
    double? amount,
    InvoiceStatus? status,
    String? notes,
    double? taxAmount,
    double? discountAmount,
  }) {
    return Invoice(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  @override
  String toString() {
    return 'Invoice(id: $id, orderId: $orderId, amount: €${amount.toStringAsFixed(2)}, status: $status, due: ${dueDate.toString().split(' ')[0]})';
  }

  /// Convert Invoice to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'issueDate': issueDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'amount': amount,
      'status': status.name,
      'notes': notes,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
    };
  }

  /// Create Invoice from JSON (Firebase)
  factory Invoice.fromJson(Map<dynamic, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      amount: (json['amount'] as num).toDouble(),
      status: InvoiceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => InvoiceStatus.draft,
      ),
      notes: json['notes'] as String?,
      taxAmount: json['taxAmount'] != null ? (json['taxAmount'] as num).toDouble() : null,
      discountAmount: json['discountAmount'] != null ? (json['discountAmount'] as num).toDouble() : null,
    );
  }
}

/// Status of an invoice
enum InvoiceStatus {
  draft,
  issued,
  paid,
  overdue,
  cancelled,
}
