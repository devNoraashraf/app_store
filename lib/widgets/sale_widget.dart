import 'package:app_store/consts/colors_manger.dart';
import 'package:flutter/material.dart';

class SaleWidget extends StatelessWidget {
  const SaleWidget({super.key, required this.imagePath});
 final String imagePath;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.28,
      width: size.width * 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.lightError,
            ColorsManager.blue.withOpacity(0.7),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
