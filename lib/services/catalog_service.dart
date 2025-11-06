import '../models/product.dart';

/// Service for managing the centralized product catalog
class CatalogService {
  final Map<String, Product> _products = {};

  /// Add a product to the catalog
  void addProduct(Product product) {
    _products[product.id] = product;
  }

  /// Get a product by ID
  Product? getProduct(String id) {
    return _products[id];
  }

  /// Get all products
  List<Product> getAllProducts() {
    return _products.values.toList();
  }

  /// Get products by category
  List<Product> getProductsByCategory(String category) {
    return _products.values
        .where((product) => product.category == category)
        .toList();
  }

  /// Search products by name
  List<Product> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _products.values
        .where((product) => product.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Update a product
  bool updateProduct(String id, Product product) {
    if (_products.containsKey(id)) {
      _products[id] = product;
      return true;
    }
    return false;
  }

  /// Remove a product from the catalog
  bool removeProduct(String id) {
    return _products.remove(id) != null;
  }

  /// Get the total number of products
  int getProductCount() {
    return _products.length;
  }

  /// List all products
  void listProducts() {
    if (_products.isEmpty) {
      print('Aucun produit dans le catalogue.');
      return;
    }
    
    _products.values.forEach((product) {
      print('  - ${product.name} (${product.category}): €${product.price.toStringAsFixed(2)} - Stock: ${product.stockQuantity}');
    });
  }

  /// Get all categories
  Set<String> getAllCategories() {
    return _products.values.map((product) => product.category).toSet();
  }
}
