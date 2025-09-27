import 'package:app_store/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_store/providers/products_provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),
      body: Builder(
        builder: (context) {
          if (prov.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("خطأ: ${prov.error}"),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: prov.fetchAll,
                    child: const Text("إعادة المحاولة"),
                  ),
                ],
              ),
            );
          }
          if (prov.items.isEmpty) {
            return const Center(child: Text("لا توجد منتجات"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: prov.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) =>
                CardWidget(product: prov.items[index]),
          );
        },
      ),
    );
  }
}
