import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/product_provider.dart';
import '../widgets/product_reviews_widget.dart';

/// Demo screen showing integration of products and reviews via Data Connect
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product info section
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                final product = provider.products
                    .where((p) => p.id == productId)
                    .firstOrNull;
                
                if (product == null) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Product not found'),
                  );
                }
                
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (product.description?.isNotEmpty == true) ...[
                          const SizedBox(height: 12),
                          Text(
                            product.description!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          'Stock: ${product.stock}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Reviews section using Data Connect
            ProductReviewsWidget(
              productId: productId,
              productName: context.read<ProductProvider>()
                  .products
                  .where((p) => p.id == productId)
                  .firstOrNull
                  ?.name ?? 'Unknown Product',
            ),
          ],
        ),
      ),
    );
  }
}