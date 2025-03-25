import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shop/core/router/app_router.dart';
import 'package:shop/core/theme/app_theme.dart';
import 'package:shop/model/cart_item.dart';
import 'package:shop/model/product.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@RoutePage()
class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedQuantity = 1;
  final PageController _imagePageController = PageController();

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  void _updateQuantity(bool increase) {
    setState(() {
      if (increase) {
        _selectedQuantity++;
      } else if (_selectedQuantity > 1) {
        _selectedQuantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        widget.product.discountPercentage != null &&
        widget.product.discountPercentage! > 0;
    final discountedPrice =
        hasDiscount && widget.product.price != null
            ? widget.product.price! -
                (widget.product.price! *
                    widget.product.discountPercentage! /
                    100)
            : widget.product.price;

    final images =
        widget.product.images?.isNotEmpty == true
            ? widget.product.images!
            : [widget.product.thumbnail ?? ''];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        scrolledUnderElevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.router.pop(),
        ),
        centerTitle: true,
        title: Text(
          "Detail Product",
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Carousel with Indicator
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 320,
                  decoration: BoxDecoration(color: AppTheme.backgroundColor),
                  child: PageView.builder(
                    controller: _imagePageController,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index],
                        fit: BoxFit.fitHeight,
                        errorBuilder:
                            (context, error, stackTrace) => const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SmoothPageIndicator(
                    controller: _imagePageController,
                    count: images.length,
                    effect: WormEffect(
                      dotColor: Colors.grey.shade400,
                      activeDotColor: AppTheme.primaryColor,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title and Brand
                  Text(
                    widget.product.title ?? 'Unknown Product',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor.withAlpha(
                        (0.95 * 255).toInt(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.brand ?? 'Unknown Brand',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  // Price and Discount
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(
                          decoration:
                              hasDiscount ? TextDecoration.lineThrough : null,
                          color: hasDiscount ? Colors.grey : Colors.black,
                          fontSize: hasDiscount ? 14 : 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (discountedPrice != null)
                        Text(
                          '\$${discountedPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (hasDiscount)
                        Text(
                          ' -${widget.product.discountPercentage?.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),

                  // Description
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.product.description ?? 'No description available.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  // Quantity Selection
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      _QuantitySelector(
                        quantity: _selectedQuantity,
                        onDecrease: () => _updateQuantity(false),
                        onIncrease: () => _updateQuantity(true),
                      ),
                    ],
                  ),

                  // Additional Product Information
                  const SizedBox(height: 16),
                  _buildProductInfo(
                    'Stock',
                    '${widget.product.stock ?? 'N/A'} available',
                  ),
                  _buildProductInfo('SKU', widget.product.sku ?? 'N/A'),
                  _buildProductInfo(
                    'Category',
                    widget.product.category ?? 'N/A',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _AddToCartButton(
        product: widget.product,
        quantity: _selectedQuantity,
      ),
    );
  }

  Widget _buildProductInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QuantitySelector({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 20),
            onPressed: onDecrease,
            visualDensity: VisualDensity.compact,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$quantity',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            onPressed: onIncrease,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _AddToCartButton extends ConsumerWidget {
  final Product product;
  final int quantity;

  const _AddToCartButton({required this.product, required this.quantity});

  void addToCart(WidgetRef ref, Product product, int quantity) {
    final cartItem = CartItemModel(
      productId: product.id!,
      title: product.title!,
      price: product.price!,
      brand: product.brand!,
      quantity: quantity,
      thumbnail: product.thumbnail!,
    );

    ref.read(cartNotifierProvider.notifier).addToCart(cartItem);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          addToCart(ref, product, quantity);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added $quantity ${product.title} to cart'),
              duration: const Duration(seconds: 2),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor.withAlpha((0.8 * 255).toInt()),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('Add to Cart'),
      ),
    );
  }
}
