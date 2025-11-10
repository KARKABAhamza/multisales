import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/review_provider.dart';
import '../../core/services/review_service.dart';

class ProductReviewsWidget extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductReviewsWidget({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ProductReviewsWidget> createState() => _ProductReviewsWidgetState();
}

class _ProductReviewsWidgetState extends State<ProductReviewsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewProvider>().fetchReviewsForProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reviews for ${widget.productName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Consumer<ReviewProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.errorMessage != null) {
                  return Column(
                    children: [
                      Text(
                        'Error: ${provider.errorMessage}',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => provider.fetchReviewsForProduct(widget.productId),
                        child: const Text('Retry'),
                      ),
                    ],
                  );
                }
                
                if (provider.reviews.isEmpty) {
                  return const Text('No reviews yet for this product.');
                }
                
                return Column(
                  children: provider.reviews.map((review) => _ReviewCard(review: review)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ProductReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${review.rating}/5',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (review.comment != null) ...[
              const SizedBox(height: 8),
              Text(
                review.comment!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}