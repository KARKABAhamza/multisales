import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
  final Map<String, dynamic> specifications;
  final bool isAvailable;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final String sku;
  final double? discountPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String vendorId;
  final List<String> tags;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrls = const [],
    this.specifications = const {},
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.sku,
    this.discountPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.vendorId,
    this.tags = const [],
  });

  // Factory constructor for creating Product from Firestore document
  factory Product.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      specifications: Map<String, dynamic>.from(data['specifications'] ?? {}),
      isAvailable: data['isAvailable'] ?? true,
      stockQuantity: data['stockQuantity'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      sku: data['sku'] ?? '',
      discountPrice: data['discountPrice']?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      vendorId: data['vendorId'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  // Convert Product to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrls': imageUrls,
      'specifications': specifications,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
      'sku': sku,
      'discountPrice': discountPrice,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'vendorId': vendorId,
      'tags': tags,
    };
  }

  // Copy with method for immutable updates
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? imageUrls,
    Map<String, dynamic>? specifications,
    bool? isAvailable,
    int? stockQuantity,
    double? rating,
    int? reviewCount,
    String? sku,
    double? discountPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? vendorId,
    List<String>? tags,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      specifications: specifications ?? this.specifications,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      sku: sku ?? this.sku,
      discountPrice: discountPrice ?? this.discountPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      vendorId: vendorId ?? this.vendorId,
      tags: tags ?? this.tags,
    );
  }

  // Calculate effective price (with discount if available)
  double get effectivePrice => discountPrice ?? price;

  // Check if product has discount
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  // Calculate discount percentage
  double get discountPercentage {
    if (!hasDiscount) return 0.0;
    return ((price - discountPrice!) / price) * 100;
  }

  // Check if product is in stock
  bool get inStock => stockQuantity > 0;

  // Get primary image URL
  String get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Product categories enum for consistency
enum ProductCategory {
  electronics('Electronics'),
  clothing('Clothing'),
  books('Books'),
  home('Home & Garden'),
  sports('Sports & Outdoors'),
  beauty('Beauty & Personal Care'),
  automotive('Automotive'),
  toys('Toys & Games'),
  food('Food & Beverages'),
  health('Health & Wellness');

  const ProductCategory(this.displayName);
  final String displayName;
}

// Product sort options
enum ProductSortOption {
  nameAsc('Name A-Z'),
  nameDesc('Name Z-A'),
  priceAsc('Price Low to High'),
  priceDesc('Price High to Low'),
  ratingDesc('Highest Rated'),
  newest('Newest First'),
  oldest('Oldest First');

  const ProductSortOption(this.displayName);
  final String displayName;
}
