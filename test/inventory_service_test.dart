import 'package:test/test.dart';
import 'package:multisales/services/inventory_service.dart';

void main() {
  group('InventoryService', () {
    late InventoryService inventoryService;

    setUp(() {
      inventoryService = InventoryService();
    });

    test('should initialize stock', () {
      inventoryService.initializeStock('P001', 100);

      expect(inventoryService.getStock('P001'), equals(100));
    });

    test('should add stock', () {
      inventoryService.initializeStock('P001', 100);
      inventoryService.addStock('P001', 50);

      expect(inventoryService.getStock('P001'), equals(150));
    });

    test('should remove stock', () {
      inventoryService.initializeStock('P001', 100);
      inventoryService.removeStock('P001', 30);

      expect(inventoryService.getStock('P001'), equals(70));
    });

    test('should not allow negative stock', () {
      inventoryService.initializeStock('P001', 10);
      final result = inventoryService.removeStock('P001', 20);

      expect(result, isFalse);
      expect(inventoryService.getStock('P001'), equals(10));
    });

    test('should check if product is in stock', () {
      inventoryService.initializeStock('P001', 50);

      expect(inventoryService.isInStock('P001', 30), isTrue);
      expect(inventoryService.isInStock('P001', 60), isFalse);
    });

    test('should get low stock products', () {
      inventoryService.initializeStock('P001', 5);
      inventoryService.initializeStock('P002', 50);
      inventoryService.initializeStock('P003', 8);

      final lowStock = inventoryService.getLowStockProducts(10);

      expect(lowStock.length, equals(2));
      expect(lowStock.containsKey('P001'), isTrue);
      expect(lowStock.containsKey('P003'), isTrue);
    });

    test('should calculate total items count', () {
      inventoryService.initializeStock('P001', 100);
      inventoryService.initializeStock('P002', 50);
      inventoryService.initializeStock('P003', 25);

      expect(inventoryService.getTotalItemsCount(), equals(175));
    });
  });
}
