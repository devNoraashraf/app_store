import 'package:app_store/consts/colors_manger.dart';
import 'package:app_store/widgets/appbar_icons.dart' show AppbarIcons;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorsManager.scaffoldBackground,
        title: const Text('Home Screen'),
        leading: AppbarIcons(
          function: () {
            // Define your function here
          },
          icon: IconlyBold.category,
          backgroundColor: ColorsManager.primary,
        ),
        actions: [
          AppbarIcons(
            function: () {
              // Define your function here
            },
            icon: IconlyBold.user3,
            backgroundColor: ColorsManager.error,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(IconlyLight.search, color: ColorsManager.grey),
              filled: true,
              fillColor: ColorsManager.lightGrey,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ColorsManager.darkGrey,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ColorsManager.error, width: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
