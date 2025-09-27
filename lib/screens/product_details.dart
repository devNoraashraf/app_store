import 'package:app_store/models/products_model.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final products product; // ✅ استخدمه

  const ProductDetails({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = (product.images?.isNotEmpty ?? false)
        ? product.images!.first
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? "Product Details"),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج من الشبكة
            Center(
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_outlined,
                        size: 120,
                      ),
                    )
                  : const Icon(Icons.image_not_supported, size: 120),
            ),
            const SizedBox(height: 20),

            // اسم المنتج
            Text(
              product.title ?? "Unnamed product",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // السعر
            Text(
              "Price: \$${product.price ?? 0}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // الوصف
            Text(
              product.description ??
                  "No description provided for this product.",
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 30),

            // زر إضافة للسلة
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: add-to-cart logic
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Add to Cart", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
