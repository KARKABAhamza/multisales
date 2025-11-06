/// Represents a product in the catalog
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stockQuantity;
  final String? description;
  final String? supplier;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stockQuantity,
    this.description,
    this.supplier,
  });

  /// Create a copy of the product with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    int? stockQuantity,
    String? description,
    String? supplier,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      description: description ?? this.description,
      supplier: supplier ?? this.supplier,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, category: $category, price: €$price, stock: $stockQuantity)';
  }
}
