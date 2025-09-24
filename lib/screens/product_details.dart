import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
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
            // صورة المنتج
            Center(
              child: Image.asset(
                "assets/images/p1.png",
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            // اسم المنتج
            const Text(
              "Product Name",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // السعر
            const Text(
              "Price: \$120",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // الوصف
            const Text(
              "This is a detailed description of the product. "
              "It explains the main features, specifications, and any "
              "additional information the customer might want to know.",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 30),

            // زرار إضافة للسلة
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // هنا تضيف وظيفة إضافة للسلة
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 18),
                ),
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
