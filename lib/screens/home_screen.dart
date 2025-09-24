import 'package:app_store/consts/colors_manger.dart';
import 'package:app_store/widgets/appbar_icons.dart' show AppbarIcons;
import 'package:app_store/widgets/sale_widget.dart';
import 'package:app_store/widgets/textfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


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
          Textfield(),
          const SizedBox(height: 20),
          SaleWidget(),
        ],
      ),
    );
  }
}
