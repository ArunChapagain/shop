import 'package:flutter/material.dart';
import 'package:shop/core/theme/app_theme.dart';
import 'package:shop/model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate discount price if available
    final hasDiscount =
        product.discountPercentage != null && product.discountPercentage! > 0;
    final discountedPrice =
        hasDiscount && product.price != null
            ? product.price! -
                (product.price! * product.discountPercentage! / 100)
            : null;

    return Container(
      // margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color.fromARGB(205, 246, 205, 184),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Add to Cart Button
          SizedBox(
            height: 170,
            width: double.infinity,
            child: Stack(
              children: [
                // Product Image
                AspectRatio(
                  aspectRatio: 1,
                  child:
                      product.thumbnail != null
                          ? Image.network(
                            product.thumbnail!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                  ),
                                ),
                          )
                          : const Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                ),

                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.7 * 255).toInt()),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart, size: 20),
                      onPressed: () {
                        // TODO: Implement add_to_cart functionality
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                // Brand
                if (product.brand != null)
                  Text(
                    product.brand!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                // Product Name
                Text(
                  product.title ?? 'Unknown Product',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 5),

                // Price and Add to Cart
                Row(
                  children: [
                    // Original Price
                    if (product.price != null)
                      Text(
                        '\$${product.price!.toStringAsFixed(2)}',
                        style: TextStyle(
                          decoration:
                              hasDiscount ? TextDecoration.lineThrough : null,
                          color:
                              hasDiscount
                                  ? const Color.fromARGB(255, 68, 68, 68)
                                  : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    const SizedBox(width: 10),

                    // Discounted Price
                    if (discountedPrice != null)
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${product.discountPercentage!.toStringAsFixed(0)}% off',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
