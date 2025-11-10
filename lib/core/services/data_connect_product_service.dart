import 'package:flutter/foundation.dart';
import '../../dataconnect_generated/generated.dart';
import 'product_service.dart';
import 'network_service.dart';
import '../../models/product_models.dart';

/// Enhanced ProductService that can use both Firestore and Data Connect
class DataConnectProductService implements ProductServiceBase {
  final _network = NetworkService();
  final _connector = ExampleConnector.instance;
  final ProductServiceBase _fallbackService = ProductService();

  @override
  Future<List<Product>> listProducts({int limit = 50}) async {
    await _network.ensureOnline();
    try {
      final result = await _connector.listProducts().execute();
      return result.data.products
          .map((p) => Product(
                id: p.id,
                name: p.name,
                description: p.description,
                price: p.price,
                stock: 0, // Data Connect doesn't include stock yet
                imageUrls: const [], // Data Connect doesn't include images yet
                active: true,
              ))
          .toList();
    } catch (e) {
      debugPrint('Data Connect failed, falling back to Firestore: $e');
      return _fallbackService.listProducts(limit: limit);
    }
  }

  @override
  Future<Product?> getProduct(String id) async {
    // For now, fallback to Firestore for individual product details
    // Could be enhanced with Data Connect GetProduct query
    return _fallbackService.getProduct(id);
  }

  @override
  Future<String> createProduct(Product p) async {
    // For now, fallback to Firestore for product creation
    // Could be enhanced with Data Connect CreateProduct mutation
    return _fallbackService.createProduct(p);
  }
}