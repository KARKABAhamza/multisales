/// Cart item model for shopping cart functionality
class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;
  final Map<String, String> options; // size, color, etc.
  final DateTime addedAt;

  const CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.options = const {},
    required this.addedAt,
  });

  /// Create copy with updated fields
  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? imageUrl,
    Map<String, String>? options,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      options: options ?? this.options,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'options': options,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String?,
      options: Map<String, String>.from(json['options'] as Map? ?? {}),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  /// Business logic methods
  double get totalPrice => price * quantity;

  String get optionsText {
    if (options.isEmpty) return '';
    return options.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(', ');
  }

  @override
  String toString() {
    return 'CartItem(id: $id, product: $productName, quantity: $quantity, total: \$${totalPrice.toStringAsFixed(2)})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
