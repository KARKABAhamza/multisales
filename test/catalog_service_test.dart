import 'package:test/test.dart';
import 'package:multisales/models/product.dart';
import 'package:multisales/services/catalog_service.dart';

void main() {
  group('CatalogService', () {
    late CatalogService catalogService;

    setUp(() {
      catalogService = CatalogService();
    });

    test('should add product to catalog', () {
      final product = Product(
        id: 'P001',
        name: 'Test Product',
        category: 'Test Category',
        price: 100.0,
        stockQuantity: 10,
      );

      catalogService.addProduct(product);

      expect(catalogService.getProductCount(), equals(1));
      expect(catalogService.getProduct('P001'), equals(product));
    });

    test('should get products by category', () {
      final product1 = Product(
        id: 'P001',
        name: 'Product 1',
        category: 'Category A',
        price: 100.0,
        stockQuantity: 10,
      );

      final product2 = Product(
        id: 'P002',
        name: 'Product 2',
        category: 'Category B',
        price: 200.0,
        stockQuantity: 20,
      );

      catalogService.addProduct(product1);
      catalogService.addProduct(product2);

      final categoryA = catalogService.getProductsByCategory('Category A');
      expect(categoryA.length, equals(1));
      expect(categoryA.first.id, equals('P001'));
    });

    test('should search products by name', () {
      final product = Product(
        id: 'P001',
        name: 'Office Chair',
        category: 'Furniture',
        price: 150.0,
        stockQuantity: 5,
      );

      catalogService.addProduct(product);

      final results = catalogService.searchProducts('chair');
      expect(results.length, equals(1));
      expect(results.first.id, equals('P001'));
    });

    test('should update product', () {
      final product = Product(
        id: 'P001',
        name: 'Test Product',
        category: 'Test',
        price: 100.0,
        stockQuantity: 10,
      );

      catalogService.addProduct(product);

      final updatedProduct = product.copyWith(price: 150.0);
      catalogService.updateProduct('P001', updatedProduct);

      expect(catalogService.getProduct('P001')?.price, equals(150.0));
    });

    test('should remove product', () {
      final product = Product(
        id: 'P001',
        name: 'Test Product',
        category: 'Test',
        price: 100.0,
        stockQuantity: 10,
      );

      catalogService.addProduct(product);
      expect(catalogService.getProductCount(), equals(1));

      catalogService.removeProduct('P001');
      expect(catalogService.getProductCount(), equals(0));
    });
  });
}
