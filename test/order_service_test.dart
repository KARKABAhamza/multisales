import 'package:test/test.dart';
import 'package:multisales/models/order.dart';
import 'package:multisales/services/order_service.dart';

void main() {
  group('OrderService', () {
    late OrderService orderService;

    setUp(() {
      orderService = OrderService();
    });

    test('should create an order', () {
      final order = Order(
        id: 'O001',
        supplierId: 'S001',
        items: [
          OrderItem(productId: 'P001', quantity: 5, unitPrice: 100.0),
        ],
        status: OrderStatus.pending,
        orderDate: DateTime.now(),
      );

      orderService.createOrder(order);

      expect(orderService.getOrderCount(), equals(1));
      expect(orderService.getOrder('O001'), equals(order));
    });

    test('should calculate order total amount', () {
      final order = Order(
        id: 'O001',
        supplierId: 'S001',
        items: [
          OrderItem(productId: 'P001', quantity: 5, unitPrice: 100.0),
          OrderItem(productId: 'P002', quantity: 2, unitPrice: 50.0),
        ],
        status: OrderStatus.pending,
        orderDate: DateTime.now(),
      );

      expect(order.totalAmount, equals(600.0));
    });

    test('should update order status', () {
      final order = Order(
        id: 'O001',
        supplierId: 'S001',
        items: [
          OrderItem(productId: 'P001', quantity: 5, unitPrice: 100.0),
        ],
        status: OrderStatus.pending,
        orderDate: DateTime.now(),
      );

      orderService.createOrder(order);
      orderService.updateOrderStatus('O001', OrderStatus.confirmed);

      expect(orderService.getOrder('O001')?.status, equals(OrderStatus.confirmed));
    });

    test('should get orders by status', () {
      final order1 = Order(
        id: 'O001',
        supplierId: 'S001',
        items: [
          OrderItem(productId: 'P001', quantity: 5, unitPrice: 100.0),
        ],
        status: OrderStatus.pending,
        orderDate: DateTime.now(),
      );

      final order2 = Order(
        id: 'O002',
        supplierId: 'S001',
        items: [
          OrderItem(productId: 'P002', quantity: 3, unitPrice: 50.0),
        ],
        status: OrderStatus.delivered,
        orderDate: DateTime.now(),
      );

      orderService.createOrder(order1);
      orderService.createOrder(order2);

      final pendingOrders = orderService.getOrdersByStatus(OrderStatus.pending);
      expect(pendingOrders.length, equals(1));
      expect(pendingOrders.first.id, equals('O001'));
    });

    test('should calculate total revenue', () {
      final order1 = Order(
        id: 'O001',
        supplierId: 'S001',
        items: [
          OrderItem(productId: 'P001', quantity: 5, unitPrice: 100.0),
        ],
        status: OrderStatus.pending,
        orderDate: DateTime.now(),
      );

      final order2 = Order(
        id: 'O002',
        supplierId: 'S001',
        items: [
          OrderItem(productId: 'P002', quantity: 2, unitPrice: 50.0),
        ],
        status: OrderStatus.delivered,
        orderDate: DateTime.now(),
      );

      orderService.createOrder(order1);
      orderService.createOrder(order2);

      expect(orderService.getTotalRevenue(), equals(600.0));
    });
  });
}
