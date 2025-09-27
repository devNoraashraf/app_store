import 'package:app_store/consts/colors_manger.dart';
import 'package:app_store/models/products_model.dart' show products;
import 'package:app_store/screens/product_details.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final products product;
  const CardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        (product.images != null && product.images!.isNotEmpty)
            ? product.images!.first
            : null;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetails(product: product)),
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
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ شلنا السعر من فوق
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child:
                      imageUrl == null
                          ? Image.asset(
                            "assets/images/p1.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                          : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder:
                                (_, __, ___) => Image.asset(
                                  "assets/images/p1.png",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                          ),
                ),
              ),

              const SizedBox(height: 8),

              // ✅ صف فيه الاسم على الشمال والسعر على اليمين
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.title ?? 'Product',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      '${product.price ?? 0} \$',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.lightPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
