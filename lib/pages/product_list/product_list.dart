import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shop/core/router/app_router.dart';
import 'package:shop/core/theme/app_theme.dart';
import 'package:shop/model/cart_item.dart';
import 'package:shop/model/product.dart';
import 'package:shop/pages/product_list/widget/product_card.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/product_provider.dart';

@RoutePage()
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  void addToCart(WidgetRef ref, Product product) {
    final cartItem = CartItemModel(
      productId: product.id!,
      title: product.title!,
      price: product.price!,
      brand: product.brand!,
      thumbnail: product.thumbnail!,
    );

    ref.read(cartNotifierProvider.notifier).addToCart(cartItem);
  }

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
              context.router.push(const CartRoute());
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
                        context.router.push(
                          ProductDetailsRoute(product: product),
                        );
                      },
                      child: ProductCard(
                        product: product,
                        onAddToCart: () {
                          addToCart(ref, product);
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
