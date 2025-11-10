import 'package:firebase_database/firebase_database.dart';
import '../models/order.dart';
import '../config/firebase_config.dart';

/// Firebase-enabled service for managing orders
class FirebaseOrderService {
  final DatabaseReference _ordersRef = FirebaseConfig.ordersRef;

  /// Create a new order
  Future<void> createOrder(Order order) async {
    await _ordersRef.child(order.id).set(order.toJson());
  }

  /// Get an order by ID
  Future<Order?> getOrder(String id) async {
    final snapshot = await _ordersRef.child(id).get();
    if (snapshot.exists) {
      return Order.fromJson(snapshot.value as Map<dynamic, dynamic>);
    }
    return null;
  }

  /// Get all orders
  Future<List<Order>> getAllOrders() async {
    final snapshot = await _ordersRef.get();
    if (!snapshot.exists) {
      return [];
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => Order.fromJson(entry.value as Map<dynamic, dynamic>))
        .toList();
  }

  /// Get orders by status
  Future<List<Order>> getOrdersByStatus(OrderStatus status) async {
    final snapshot = await _ordersRef
        .orderByChild('status')
        .equalTo(status.name)
        .get();
    
    if (!snapshot.exists) {
      return [];
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => Order.fromJson(entry.value as Map<dynamic, dynamic>))
        .toList();
  }

  /// Get orders by supplier
  Future<List<Order>> getOrdersBySupplier(String supplierId) async {
    final snapshot = await _ordersRef
        .orderByChild('supplierId')
        .equalTo(supplierId)
        .get();
    
    if (!snapshot.exists) {
      return [];
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => Order.fromJson(entry.value as Map<dynamic, dynamic>))
        .toList();
  }

  /// Update order status
  Future<bool> updateOrderStatus(String id, OrderStatus newStatus) async {
    try {
      await _ordersRef.child(id).update({'status': newStatus.name});
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Cancel an order
  Future<bool> cancelOrder(String id) async {
    return updateOrderStatus(id, OrderStatus.cancelled);
  }

  /// Get the total number of orders
  Future<int> getOrderCount() async {
    final snapshot = await _ordersRef.get();
    if (!snapshot.exists) {
      return 0;
    }
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.length;
  }

  /// Calculate total revenue from all orders
  Future<double> getTotalRevenue() async {
    final orders = await getAllOrders();
    return orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  /// Get orders within a date range (inclusive) - client-side filtering
  Future<List<Order>> getOrdersByDateRange(DateTime start, DateTime end) async {
    final allOrders = await getAllOrders();
    return allOrders
        .where((order) =>
            !order.orderDate.isBefore(start) && !order.orderDate.isAfter(end))
        .toList();
  }

  /// Listen to real-time updates for all orders
  Stream<List<Order>> watchOrders() {
    return _ordersRef.onValue.map((event) {
      if (!event.snapshot.exists) {
        return <Order>[];
      }
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return data.entries
          .map((entry) => Order.fromJson(entry.value as Map<dynamic, dynamic>))
          .toList();
    });
  }

  /// Listen to real-time updates for a specific order
  Stream<Order?> watchOrder(String id) {
    return _ordersRef.child(id).onValue.map((event) {
      if (!event.snapshot.exists) {
        return null;
      }
      return Order.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
    });
  }
}
