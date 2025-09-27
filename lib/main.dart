import 'package:app_store/providers/products_provider.dart' show ProductsProvider;
import 'package:app_store/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;

void main() {
 runApp(
    ChangeNotifierProvider(
      create: (_) => ProductsProvider(), // هنجيب الداتا مرة واحدة
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}
