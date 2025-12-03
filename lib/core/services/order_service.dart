import 'package:cloud_firestore/cloud_firestore.dart';
import 'network_service.dart';
import '../../models/product_models.dart';

abstract class OrderServiceBase {
  Future<String> placeOrder({required String userId, required List<OrderItem> items});
  Future<OrderModel?> getOrder(String id);
  Future<List<OrderModel>> listOrdersForUser(String userId, {int limit = 50});
}

class OrderService implements OrderServiceBase {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  final _network = NetworkService();

  @override
  Future<String> placeOrder({required String userId, required List<OrderItem> items}) async {
    await _network.ensureOnline();
    final total = items.fold<double>(0.0, (acc, it) => acc + (it.unitPrice * it.qty));
    final payload = {
      'userId': userId,
      'items': items
          .map((e) => {
                'productId': e.productId,
                'quantity': e.qty, // stored as 'quantity' for backend triggers
                'unitPrice': e.unitPrice,
              })
          .toList(),
      'total': total,
      'status': 'created',
      'createdAt': FieldValue.serverTimestamp(),
    };
    final ref = await _db.collection('orders').add(payload);
    return ref.id;
  }

  @override
  Future<OrderModel?> getOrder(String id) async {
    await _network.ensureOnline();
    final doc = await _db.collection('orders').doc(id).get();
    if (!doc.exists) return null;
    return _mapOrder(doc);
  }

  @override
  Future<List<OrderModel>> listOrdersForUser(String userId, {int limit = 50}) async {
    await _network.ensureOnline();
    final q = await _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return q.docs.map((doc) => _mapOrder(doc)).toList();
  }

  OrderModel _mapOrder(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final items = (data['items'] as List? ?? const [])
        .map((e) => OrderItem(
              productId: (e['productId'] ?? '').toString(),
              qty: (e['qty'] ?? e['quantity'] ?? 0 as num).toInt(),
              unitPrice: (e['unitPrice'] is int)
                  ? (e['unitPrice'] as int).toDouble()
                  : (e['unitPrice'] as num?)?.toDouble() ?? 0.0,
            ))
        .toList();
    final total = (data['total'] is num)
        ? (data['total'] as num).toDouble()
        : items.fold<double>(0.0, (acc, it) => acc + (it.unitPrice * it.qty));
    return OrderModel(
      id: doc.id,
      userId: (data['userId'] ?? '').toString(),
      items: items,
      total: total,
      status: (data['status'] ?? 'created').toString(),
      createdAt: (data['createdAt'] is Timestamp) ? (data['createdAt'] as Timestamp).toDate() : null,
    );
  }
}
