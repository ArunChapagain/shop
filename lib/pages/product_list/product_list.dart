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
class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final productState = ref.read(productNotifierProvider);

    // When user scrolls to ~80% of the list, load more products
    if (currentScroll >= maxScroll * 0.8 &&
        !productState.isLoading &&
        !productState.hasReachedMax) {
      ref.read(productNotifierProvider.notifier).loadProducts();
    }
  }

  void addToCart(Product product) {
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
  Widget build(BuildContext context) {
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
                child:
                    productState.products.isEmpty && productState.isLoading
                        // Show centered loader for initial loading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            // Grid of products
                            SliverPadding(
                              padding: const EdgeInsets.all(5),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.65,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
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
                                        addToCart(product);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${product.title} added to cart',
                                            ),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                            backgroundColor:
                                                AppTheme.primaryColor,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }, childCount: productState.products.length),
                              ),
                            ),

                            // Loading indicator or end of list message
                            SliverToBoxAdapter(
                              child:
                                  productState.hasReachedMax
                                      ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text('No more products'),
                                      )
                                      : productState.isLoading &&
                                          productState.products.isNotEmpty
                                      ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        alignment: Alignment.center,
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
              ),
    );
  }
}
