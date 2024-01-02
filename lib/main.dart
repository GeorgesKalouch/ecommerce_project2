import 'package:flutter/material.dart';
import 'package:project2/Components/Themes.dart';
import 'package:project2/Login.dart';
import 'package:project2/cart_page.dart';
import 'package:project2/shop_page.dart';
import 'package:provider/provider.dart';
import 'Components/shop.dart';
import 'into_page.dart';


void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Shop(),
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
      home: Login(),
      theme: lightMode,
      routes: {
        '/into_page' : (context) => const IntroPage(),
        '/shop_page' : (context) => const ShopPage(),
        '/cart_page' : (context) => const CartPage(),
      },
    );
  }
}
