import 'package:flutter_test/flutter_test.dart';
import 'package:multisales_app/core/providers/product_provider.dart';
import 'package:multisales_app/core/services/product_service.dart';
import 'package:multisales_app/models/product_models.dart';

class _FakeProductService implements ProductServiceBase {
  @override
  Future<String> createProduct(Product p) async => 'p1';

  @override
  Future<Product?> getProduct(String id) async =>
      const Product(id: 'p1', name: 'Demo', price: 10.0, stock: 5);

  @override
  Future<List<Product>> listProducts({int limit = 50}) async =>
      [const Product(id: 'p1', name: 'Demo', price: 10.0, stock: 5)];
}

void main() {
  test('ProductProvider fetchProducts populates products and clears error', () async {
  final provider = ProductProvider(service: _FakeProductService());

    await provider.fetchProducts();

    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNull);
    expect(provider.products, isNotEmpty);
    expect(provider.products.first.name, 'Demo');
  });
}
