import 'package:app_store/consts/colors_manger.dart';
import 'package:app_store/models/products_model.dart' show products;
import 'package:app_store/screens/product_details.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final products product;   // ✅ لازم هنا
  const CardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = (product.images != null && product.images!.isNotEmpty)
        ? product.images!.first
        : null;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetails(product: product), // ✅ نبعته للتفاصيل
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorsManager.lightGrey, ColorsManager.grey],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${product.price ?? 0} \$',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.favorite_border, color: Colors.red),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageUrl == null
                      ? Image.asset(
                          "assets/images/p1.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Image.asset(
                            "assets/images/p1.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title ?? 'Product',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
