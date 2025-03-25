import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/core/theme/app_theme.dart';
import 'package:shop/pages/product_details/product_details.dart';
import 'package:shop/pages/product_list/widget/product_card.dart';
import 'package:shop/provider/product_provider.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Implement cart navigation
            },
          ),
        ],
      ),
      body:
          productState.hasError
              ? Center(child: Text('Error: ${productState.errorMessage}'))
              : RefreshIndicator(
                onRefresh: () async {
                  ref.read(productNotifierProvider.notifier).refresh();
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(5),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: productState.products.length + 1,
                  itemBuilder: (context, index) {
                    // If we're at the end of the list - handle pagination
                    if (index == productState.products.length) {
                      if (productState.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (productState.hasReachedMax) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text('No more products'),
                          ),
                        );
                      }
                      // Request more items
                      else {
                        Future.microtask(() {
                          ref
                              .read(productNotifierProvider.notifier)
                              .loadProducts();
                        });
                        return const Center(child: CircularProgressIndicator());
                      }
                    }

                    // Display product card
                    final product = productState.products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    ProductDetailsScreen(product: product),
                          ),
                        );
                      },
                      child: ProductCard(
                        product: product,
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.title} added to cart'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
