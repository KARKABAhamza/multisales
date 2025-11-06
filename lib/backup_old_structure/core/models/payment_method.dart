/// Payment method model for handling different payment options
class PaymentMethod {
  final String id;
  final String
      type; // credit_card, debit_card, digital_wallet, bank_transfer, cash_on_delivery
  final String displayName;
  final bool isDefault;
  final String? cardBrand; // visa, mastercard, amex, etc.
  final String? lastFour;
  final int? expiryMonth;
  final int? expiryYear;
  final String? bankName;
  final Map<String, dynamic> metadata;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    required this.isDefault,
    this.cardBrand,
    this.lastFour,
    this.expiryMonth,
    this.expiryYear,
    this.bankName,
    this.metadata = const {},
  });

  /// Create copy with updated fields
  PaymentMethod copyWith({
    String? id,
    String? type,
    String? displayName,
    bool? isDefault,
    String? cardBrand,
    String? lastFour,
    int? expiryMonth,
    int? expiryYear,
    String? bankName,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      isDefault: isDefault ?? this.isDefault,
      cardBrand: cardBrand ?? this.cardBrand,
      lastFour: lastFour ?? this.lastFour,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      bankName: bankName ?? this.bankName,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'displayName': displayName,
      'isDefault': isDefault,
      'cardBrand': cardBrand,
      'lastFour': lastFour,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'bankName': bankName,
      'metadata': metadata,
    };
  }

  /// Create from JSON
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      type: json['type'] as String,
      displayName: json['displayName'] as String,
      isDefault: json['isDefault'] as bool,
      cardBrand: json['cardBrand'] as String?,
      lastFour: json['lastFour'] as String?,
      expiryMonth: json['expiryMonth'] as int?,
      expiryYear: json['expiryYear'] as int?,
      bankName: json['bankName'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Business logic methods
  bool get isCreditCard => type == 'credit_card';
  bool get isDebitCard => type == 'debit_card';
  bool get isDigitalWallet => type == 'digital_wallet';
  bool get isBankTransfer => type == 'bank_transfer';
  bool get isCashOnDelivery => type == 'cash_on_delivery';

  bool get isExpired {
    if (expiryMonth == null || expiryYear == null) return false;

    final now = DateTime.now();
    final expiry = DateTime(expiryYear!, expiryMonth!);
    return now.isAfter(expiry);
  }

  String get typeDisplayName {
    switch (type) {
      case 'credit_card':
        return 'Credit Card';
      case 'debit_card':
        return 'Debit Card';
      case 'digital_wallet':
        return 'Digital Wallet';
      case 'bank_transfer':
        return 'Bank Transfer';
      case 'cash_on_delivery':
        return 'Cash on Delivery';
      default:
        return type.toUpperCase();
    }
  }

  @override
  String toString() {
    return 'PaymentMethod(id: $id, type: $type, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethod && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
