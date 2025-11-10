import 'package:flutter_test/flutter_test.dart';
import 'package:multisales_app/core/providers/order_provider.dart';
import 'package:multisales_app/core/services/order_service.dart';
import 'package:multisales_app/models/product_models.dart';

class _FakeOrderService implements OrderServiceBase {
  @override
  Future<OrderModel?> getOrder(String id) async => null;

  @override
  Future<List<OrderModel>> listOrdersForUser(String userId, {int limit = 50}) async => [];

  @override
  Future<String> placeOrder({required String userId, required List<OrderItem> items}) async => 'order_123';
}

void main() {
  test('OrderProvider placeOrder returns an id and sets loading properly', () async {
  final provider = OrderProvider(service: _FakeOrderService());
    final id = await provider.placeOrder(
      userId: 'u1',
      items: const [OrderItem(productId: 'p1', qty: 2, unitPrice: 5.0)],
    );

    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNull);
    expect(id, 'order_123');
  });
}
