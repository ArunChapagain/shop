import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/provider/product_provider.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(productNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      body: productState.hasError
          ? Center(child: Text('Error: ${productState.errorMessage}'))
          : RefreshIndicator(
              onRefresh: () async {
                ref.read(productNotifierProvider.notifier).refresh();
              },
              child: ListView.builder(
                itemCount: productState.products.length + 1,
                itemBuilder: (context, index) {
                  // If we're at the end of the list
                  if (index == productState.products.length) {
                    // Check if we're loading more items
                    if (productState.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } 
                    // Check if we've reached the maximum
                    else if (productState.hasReachedMax) {
                      return const Center(child: Text('No more products'));
                    } 
                    // Request more items
                    else {
                      Future.microtask(() {
                        ref.read(productNotifierProvider.notifier).loadProducts();
                      });
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
                  
                  // Display product item
                  final product = productState.products[index];
                  return ListTile(
                    title: Text(product.title ?? 'No title'),
                    subtitle: Text('\$${product.price}'),
                    leading: product.thumbnail != null
                        ? Image.network(
                            product.thumbnail!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          )
                        : const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
    );
  }
}