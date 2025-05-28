import 'package:flutter/material.dart';
import 'package:provider_app/model/product.dart'; // adjust import

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(double? price, double? discountPercentage) {
    if (price == null) return const SizedBox();

    final hasDiscount = discountPercentage != null && discountPercentage > 0;

    final discountedPrice =
        hasDiscount ? price * (1 - discountPercentage / 100) : price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasDiscount) ...[
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          '\$${discountedPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '-${discountPercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? 'Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.thumbnail ?? '',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              product.title ?? 'No Title',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            _buildPriceSection(product.price, product.discountPercentage),
            const SizedBox(height: 12),

            // Info Section
            const Text(
              'Product Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 1),

            Text(
              product.description ?? 'No description available.',
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),

            _buildInfoRow(Icons.category, 'Category:', product.category),
            _buildInfoRow(Icons.branding_watermark, 'Brand:', product.brand),
            // _buildInfoRow(
            //     Icons.price_check,
            //     'Price:',
            //     product.price != null
            //         ? '\$${product.price!.toStringAsFixed(2)}'
            //         : null),
            // _buildInfoRow(
            //     Icons.discount,
            //     'Discount:',
            //     product.discountPercentage != null
            //         ? '${product.discountPercentage!.toStringAsFixed(1)}%'
            //         : null),
            _buildInfoRow(
                Icons.star, 'Rating:', product.rating?.toStringAsFixed(1)),
            _buildInfoRow(Icons.inventory, 'Stock:', product.stock?.toString()),

            const SizedBox(height: 20),

            // Tags
            if (product.tags != null && product.tags!.isNotEmpty) ...[
              const Text('Tags',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: product.tags!
                    .map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Colors.blue.shade100,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],

            // Dimensions (if available)
            if (product.dimensions != null) ...[
              const Text('Dimensions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                  "W: ${product.dimensions!.width} cm, H: ${product.dimensions!.height} cm, D: ${product.dimensions!.depth} cm"),
              const SizedBox(height: 20),
            ],

            // Warranty, Shipping, Return Policy
            if (product.warrantyInformation != null)
              _buildInfoRow(
                  Icons.verified, 'Warranty:', product.warrantyInformation),
            if (product.shippingInformation != null)
              _buildInfoRow(Icons.local_shipping, 'Shipping:',
                  product.shippingInformation),
            if (product.returnPolicy != null)
              _buildInfoRow(Icons.assignment_return, 'Return Policy:',
                  product.returnPolicy),

            const SizedBox(height: 30),

            // More Images
            if (product.images != null && product.images!.isNotEmpty) ...[
              const Text('More Images',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: product.images!.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.images![i],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\$${(product.price! * (1 - (product.discountPercentage ?? 0) / 100)).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                if (product.discountPercentage != null &&
                    product.discountPercentage! > 0)
                  Text(
                    '\$${product.price!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Handle add to cart
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              label: const Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
