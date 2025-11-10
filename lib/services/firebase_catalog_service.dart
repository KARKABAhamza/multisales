import 'package:firebase_database/firebase_database.dart';
import '../models/product.dart';
import '../config/firebase_config.dart';

/// Firebase-enabled service for managing the centralized product catalog
class FirebaseCatalogService {
  final DatabaseReference _productsRef = FirebaseConfig.productsRef;

  /// Add a product to the catalog
  Future<void> addProduct(Product product) async {
    await _productsRef.child(product.id).set(product.toJson());
  }

  /// Get a product by ID
  Future<Product?> getProduct(String id) async {
    final snapshot = await _productsRef.child(id).get();
    if (snapshot.exists) {
      return Product.fromJson(snapshot.value as Map<dynamic, dynamic>);
    }
    return null;
  }

  /// Get all products
  Future<List<Product>> getAllProducts() async {
    final snapshot = await _productsRef.get();
    if (!snapshot.exists) {
      return [];
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => Product.fromJson(entry.value as Map<dynamic, dynamic>))
        .toList();
  }

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    final snapshot = await _productsRef
        .orderByChild('category')
        .equalTo(category)
        .get();
    
    if (!snapshot.exists) {
      return [];
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => Product.fromJson(entry.value as Map<dynamic, dynamic>))
        .toList();
  }

  /// Search products by name (client-side filtering)
  Future<List<Product>> searchProducts(String query) async {
    final allProducts = await getAllProducts();
    final lowerQuery = query.toLowerCase();
    return allProducts
        .where((product) => product.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Update a product
  Future<bool> updateProduct(String id, Product product) async {
    try {
      await _productsRef.child(id).update(product.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove a product from the catalog
  Future<bool> removeProduct(String id) async {
    try {
      await _productsRef.child(id).remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the total number of products
  Future<int> getProductCount() async {
    final snapshot = await _productsRef.get();
    if (!snapshot.exists) {
      return 0;
    }
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.length;
  }

  /// Listen to real-time updates for all products
  Stream<List<Product>> watchProducts() {
    return _productsRef.onValue.map((event) {
      if (!event.snapshot.exists) {
        return <Product>[];
      }
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return data.entries
          .map((entry) => Product.fromJson(entry.value as Map<dynamic, dynamic>))
          .toList();
    });
  }

  /// Listen to real-time updates for a specific product
  Stream<Product?> watchProduct(String id) {
    return _productsRef.child(id).onValue.map((event) {
      if (!event.snapshot.exists) {
        return null;
      }
      return Product.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
    });
  }
}
