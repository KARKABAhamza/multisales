import 'package:firebase_database/firebase_database.dart';
import '../config/firebase_config.dart';

/// Firebase-enabled service for managing inventory and stock levels
class FirebaseInventoryService {
  final DatabaseReference _inventoryRef = FirebaseConfig.inventoryRef;

  /// Initialize stock for a product
  Future<void> initializeStock(String productId, int quantity) async {
    await _inventoryRef.child(productId).set(quantity);
  }

  /// Get current stock level for a product
  Future<int> getStock(String productId) async {
    final snapshot = await _inventoryRef.child(productId).get();
    if (snapshot.exists) {
      return snapshot.value as int;
    }
    return 0;
  }

  /// Update stock level (can be positive or negative)
  Future<bool> updateStock(String productId, int change) async {
    try {
      final currentStock = await getStock(productId);
      final newStock = currentStock + change;
      
      if (newStock < 0) {
        print('Erreur: Stock insuffisant pour le produit $productId');
        return false;
      }
      
      await _inventoryRef.child(productId).set(newStock);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Add stock (receive inventory)
  Future<bool> addStock(String productId, int quantity) async {
    if (quantity <= 0) {
      return false;
    }
    return updateStock(productId, quantity);
  }

  /// Remove stock (for orders)
  Future<bool> removeStock(String productId, int quantity) async {
    if (quantity <= 0) {
      return false;
    }
    return updateStock(productId, -quantity);
  }

  /// Check if a product is in stock
  Future<bool> isInStock(String productId, int requiredQuantity) async {
    final stock = await getStock(productId);
    return stock >= requiredQuantity;
  }

  /// Get products with low stock (below threshold)
  Future<Map<String, int>> getLowStockProducts(int threshold) async {
    final snapshot = await _inventoryRef.get();
    if (!snapshot.exists) {
      return {};
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    final lowStock = <String, int>{};
    
    data.forEach((key, value) {
      final quantity = value as int;
      if (quantity < threshold) {
        lowStock[key as String] = quantity;
      }
    });
    
    return lowStock;
  }

  /// Get all inventory levels
  Future<Map<String, int>> getAllInventory() async {
    final snapshot = await _inventoryRef.get();
    if (!snapshot.exists) {
      return {};
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Map<String, int>.from(data);
  }

  /// Get total number of items in inventory
  Future<int> getTotalItemsCount() async {
    final inventory = await getAllInventory();
    return inventory.values.fold(0, (sum, qty) => sum + qty);
  }

  /// Listen to real-time updates for all inventory
  Stream<Map<String, int>> watchInventory() {
    return _inventoryRef.onValue.map((event) {
      if (!event.snapshot.exists) {
        return <String, int>{};
      }
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return Map<String, int>.from(data);
    });
  }

  /// Listen to real-time updates for a specific product's stock
  Stream<int> watchStock(String productId) {
    return _inventoryRef.child(productId).onValue.map((event) {
      if (!event.snapshot.exists) {
        return 0;
      }
      return event.snapshot.value as int;
    });
  }
}
