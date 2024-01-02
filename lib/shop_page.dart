import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:project2/Components/my_drawer.dart';
import 'package:project2/Components/my_product_tile.dart';
import 'package:http/http.dart' as http;


EncryptedSharedPreferences encryptedData = EncryptedSharedPreferences();

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Map<String, dynamic>> products=[];
  Future<int> getProducts() async {
    const phpEndPoint =
        "https://georges-kalouch.000webhostapp.com/getAllProducts.php";

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Successful login
        List<Map<String, dynamic>> jsonProducts =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        setState(() {
          products = jsonProducts;
        });

      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return 0;
    }
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Shop Page"),
        actions: [
          //got to cart button
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/cart_page'),
              icon: const Icon(Icons.shopping_cart_outlined))
        ],
      ),
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          const SizedBox(height: 25),

          //shop subtitle
          Center(
              child: Text(
            "Pick from a selected list of premium products",
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          )),

          //product List
          SizedBox(
            height: 550,
            child: ListView.builder(
                itemCount: products.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  //get each individual product from shop
                  final product = products[index];

                  //return as a product tile UI
                  return MyProductTile(product: products[index]);
                }),
          )
        ],
      ),
    );
  }
}
