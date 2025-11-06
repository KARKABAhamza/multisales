/// Service for managing inventory and stock levels
class InventoryService {
  final Map<String, int> _inventory = {};

  /// Initialize stock for a product
  void initializeStock(String productId, int quantity) {
    _inventory[productId] = quantity;
  }

  /// Get current stock level for a product
  int getStock(String productId) {
    return _inventory[productId] ?? 0;
  }

  /// Update stock level (can be positive or negative)
  bool updateStock(String productId, int change) {
    final currentStock = getStock(productId);
    final newStock = currentStock + change;
    
    if (newStock < 0) {
      print('Erreur: Stock insuffisant pour le produit $productId');
      return false;
    }
    
    _inventory[productId] = newStock;
    return true;
  }

  /// Add stock (receive inventory)
  bool addStock(String productId, int quantity) {
    if (quantity <= 0) {
      return false;
    }
    return updateStock(productId, quantity);
  }

  /// Remove stock (for orders)
  bool removeStock(String productId, int quantity) {
    if (quantity <= 0) {
      return false;
    }
    return updateStock(productId, -quantity);
  }

  /// Check if a product is in stock
  bool isInStock(String productId, int requiredQuantity) {
    return getStock(productId) >= requiredQuantity;
  }

  /// Get products with low stock (below threshold)
  Map<String, int> getLowStockProducts(int threshold) {
    return Map.fromEntries(
      _inventory.entries.where((entry) => entry.value < threshold),
    );
  }

  /// Get all inventory levels
  Map<String, int> getAllInventory() {
    return Map.from(_inventory);
  }

  /// Get total number of items in inventory
  int getTotalItemsCount() {
    return _inventory.values.fold(0, (sum, qty) => sum + qty);
  }
}
