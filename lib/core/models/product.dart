/// Product model for MultiSales app
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String categoryName;
  final List<String> imageUrls;
  final List<String> features;
  final Map<String, dynamic> specifications;
  final bool isAvailable;
  final bool isFeatured;
  final int stockQuantity;
  final String sku;
  final double? originalPrice;
  final double? discount;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    this.imageUrls = const [],
    this.features = const [],
    this.specifications = const {},
    this.isAvailable = true,
    this.isFeatured = false,
    this.stockQuantity = 0,
    required this.sku,
    this.originalPrice,
    this.discount,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create Product from Firestore document
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      features: List<String>.from(map['features'] ?? []),
      specifications: Map<String, dynamic>.from(map['specifications'] ?? {}),
      isAvailable: map['isAvailable'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
      stockQuantity: map['stockQuantity'] ?? 0,
      sku: map['sku'] ?? '',
      originalPrice: map['originalPrice']?.toDouble(),
      discount: map['discount']?.toDouble(),
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// Convert Product to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrls': imageUrls,
      'features': features,
      'specifications': specifications,
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
      'stockQuantity': stockQuantity,
      'sku': sku,
      'originalPrice': originalPrice,
      'discount': discount,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Check if product is on sale
  bool get isOnSale => originalPrice != null && originalPrice! > price;

  /// Get discount percentage
  double get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return 0.0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  /// Get formatted price
  String getFormattedPrice({String currency = 'USD'}) {
    switch (currency) {
      case 'EUR':
        return '€${price.toStringAsFixed(2)}';
      case 'GBP':
        return '£${price.toStringAsFixed(2)}';
      default:
        return '\$${price.toStringAsFixed(2)}';
    }
  }

  /// Get main image URL
  String? get mainImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  /// Check if product is in stock
  bool get isInStock => stockQuantity > 0;

  /// Check if product is low in stock
  bool get isLowStock => stockQuantity > 0 && stockQuantity <= 10;

  /// Create a copy with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? categoryId,
    String? categoryName,
    List<String>? imageUrls,
    List<String>? features,
    Map<String, dynamic>? specifications,
    bool? isAvailable,
    bool? isFeatured,
    int? stockQuantity,
    String? sku,
    double? originalPrice,
    double? discount,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imageUrls: imageUrls ?? this.imageUrls,
      features: features ?? this.features,
      specifications: specifications ?? this.specifications,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      sku: sku ?? this.sku,
      originalPrice: originalPrice ?? this.originalPrice,
      discount: discount ?? this.discount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
