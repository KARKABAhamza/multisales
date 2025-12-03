import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'network_service.dart';

abstract class ReviewServiceBase {
  Future<List<ProductReview>> getReviewsForProduct(String productId);
  Future<String> addReview(String productId, int rating, String? comment);
}

class ReviewService implements ReviewServiceBase {
  final _network = NetworkService();
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  @override
  Future<List<ProductReview>> getReviewsForProduct(String productId) async {
    await _network.ensureOnline();
    final query = await _db
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();
    
    return query.docs.map((doc) {
      final data = doc.data();
      return ProductReview(
        id: doc.id,
        rating: (data['rating'] as num?)?.toInt() ?? 5,
        comment: data['comment'] as String?,
        productId: data['productId'] as String,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      );
    }).toList();
  }

  @override
  Future<String> addReview(String productId, int rating, String? comment) async {
    await _network.ensureOnline();
    final data = {
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    };
    final ref = await _db.collection('reviews').add(data);
    return ref.id;
  }
}

@immutable
class ProductReview {
  final String id;
  final int rating;
  final String? comment;
  final String productId;
  final DateTime? createdAt;

  const ProductReview({
    required this.id,
    required this.rating,
    this.comment,
    required this.productId,
    this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductReview &&
          id == other.id &&
          rating == other.rating &&
          comment == other.comment &&
          productId == other.productId);

  @override
  int get hashCode => Object.hash(id, rating, comment, productId);
}