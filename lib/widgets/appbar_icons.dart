import 'package:app_store/consts/colors_manger.dart';
import 'package:flutter/material.dart';

class AppbarIcons extends StatelessWidget {
  const AppbarIcons({super.key, required this.function, required this.icon, required this.backgroundColor});
  final Function function;
  final IconData icon;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function(),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsManger.white,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: backgroundColor),
        ),
      ),
    );
  }
}
