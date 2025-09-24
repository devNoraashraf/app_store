import 'package:app_store/consts/colors_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class Textfield extends StatelessWidget {
  Textfield({super.key});
  final TextEditingController _searchController = TextEditingController();

  void dispose() {
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: Icon(IconlyLight.search, color: ColorsManager.grey),
          filled: true,
          fillColor: ColorsManager.lightGrey,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: ColorsManager.darkGrey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: ColorsManager.error, width: 1.0),
          ),
        ),
      ),
    );
  }
}
