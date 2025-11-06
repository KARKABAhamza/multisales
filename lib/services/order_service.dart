import '../models/order.dart';

/// Service for managing orders
class OrderService {
  final Map<String, Order> _orders = {};

  /// Create a new order
  void createOrder(Order order) {
    _orders[order.id] = order;
  }

  /// Get an order by ID
  Order? getOrder(String id) {
    return _orders[id];
  }

  /// Get all orders
  List<Order> getAllOrders() {
    return _orders.values.toList();
  }

  /// Get orders by status
  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.values
        .where((order) => order.status == status)
        .toList();
  }

  /// Get orders by supplier
  List<Order> getOrdersBySupplier(String supplierId) {
    return _orders.values
        .where((order) => order.supplierId == supplierId)
        .toList();
  }

  /// Update order status
  bool updateOrderStatus(String id, OrderStatus newStatus) {
    final order = _orders[id];
    if (order != null) {
      _orders[id] = order.copyWith(status: newStatus);
      return true;
    }
    return false;
  }

  /// Cancel an order
  bool cancelOrder(String id) {
    return updateOrderStatus(id, OrderStatus.cancelled);
  }

  /// Get the total number of orders
  int getOrderCount() {
    return _orders.length;
  }

  /// Calculate total revenue from all orders
  double getTotalRevenue() {
    return _orders.values.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  /// Get orders within a date range (inclusive)
  List<Order> getOrdersByDateRange(DateTime start, DateTime end) {
    return _orders.values
        .where((order) =>
            !order.orderDate.isBefore(start) && !order.orderDate.isAfter(end))
        .toList();
  }
}
