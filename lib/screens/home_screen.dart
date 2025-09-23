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
        centerTitle: true,
        title: const Text('Home Screen'),
        leading: Row(
          children: [
            Flexible(
              child: AppbarIcons(
                function: () {
                  // Define your function here
                },
                icon: IconlyBold.category,
                backgroundColor: ColorsManger.primary,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: AppbarIcons(
                function: () {
                  // Define your function here
                },
                icon: IconlyBold.search,
                backgroundColor: ColorsManger.primary,
              ),
            ),
          ],
        ),
        actions: [
          AppbarIcons(
            function: () {
              // Define your function here
            },
            icon: IconlyBold.user3,
            backgroundColor: ColorsManger.primary,
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Home Screen!')),
    );
  }
}
