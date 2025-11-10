import 'package:cloud_firestore/cloud_firestore.dart';
import 'network_service.dart';
import '../../models/product_models.dart';

abstract class ProductServiceBase {
  Future<List<Product>> listProducts({int limit = 50});
  Future<Product?> getProduct(String id);
  Future<String> createProduct(Product p);
}

class ProductService implements ProductServiceBase {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  final _network = NetworkService();

  @override
  Future<List<Product>> listProducts({int limit = 50}) async {
    await _network.ensureOnline();
    final query = await _db
        .collection('products')
        .where('active', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return query.docs.map((d) => Product.fromSnapshot(d)).toList();
  }

  @override
  Future<Product?> getProduct(String id) async {
    await _network.ensureOnline();
    final doc = await _db.collection('products').doc(id).get();
    if (!doc.exists) return null;
    return Product.fromSnapshot(doc);
  }

  @override
  Future<String> createProduct(Product p) async {
    await _network.ensureOnline();
    final ref = await _db.collection('products').add(p.toMap());
    return ref.id;
  }
}
