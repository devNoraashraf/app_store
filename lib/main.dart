import 'package:app_store/screens/cart.dart' show CartScreen;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_store/providers/products_provider.dart';
import 'package:app_store/providers/cart_provider.dart';
import 'package:app_store/screens/home_screen.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsProvider()..fetchAll(), // جيب الداتا مرة واحدة
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(), // السلة
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/cart': (_) => const CartScreen(), // روّت سريع للسلة
      },
    );
  }
}
