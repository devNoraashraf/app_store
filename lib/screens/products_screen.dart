import 'package:app_store/widgets/card_widget.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),

        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 2,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) => CardWidget(),
      ),
    );
  }
}
