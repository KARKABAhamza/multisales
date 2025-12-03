import 'package:flutter_test/flutter_test.dart';
import 'package:multisales_app/core/providers/review_provider.dart';
import 'package:multisales_app/core/services/review_service.dart';

class _FakeReviewService implements ReviewServiceBase {
  @override
  Future<List<ProductReview>> getReviewsForProduct(String productId) async => [
        const ProductReview(id: 'r1', rating: 5, comment: 'Great product!', productId: 'p1'),
        const ProductReview(id: 'r2', rating: 4, comment: 'Good quality', productId: 'p1'),
      ];

  @override
  Future<String> addReview(String productId, int rating, String? comment) async => 'review_123';
}

void main() {
  test('ReviewProvider fetchReviewsForProduct populates reviews and clears error', () async {
    final provider = ReviewProvider(service: _FakeReviewService());

    await provider.fetchReviewsForProduct('product123');

    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNull);
    expect(provider.reviews, isNotEmpty);
    expect(provider.reviews.length, 2);
    expect(provider.reviews.first.rating, 5);
    expect(provider.reviews.first.comment, 'Great product!');
  });

  test('ReviewProvider clearReviews empties the list', () async {
    final provider = ReviewProvider(service: _FakeReviewService());
    
    await provider.fetchReviewsForProduct('product123');
    expect(provider.reviews, isNotEmpty);
    
    provider.clearReviews();
    expect(provider.reviews, isEmpty);
    expect(provider.errorMessage, isNull);
  });

  test('ReviewProvider addReview returns id and refreshes reviews', () async {
    final provider = ReviewProvider(service: _FakeReviewService());
    
    final id = await provider.addReview('product123', 4, 'Nice product');
    
    expect(id, 'review_123');
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNull);
    expect(provider.reviews, isNotEmpty); // Should refresh after adding
  });
}