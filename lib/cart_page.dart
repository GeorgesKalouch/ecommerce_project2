import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project2/Components/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'Components/shop.dart';
EncryptedSharedPreferences encryptedData = EncryptedSharedPreferences();

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  List<Map<String, dynamic>> products=[];
  Future<int> getCartProduct() async {
    const phpEndPoint =
        "https://georges-kalouch.000webhostapp.com/ShowCart.php";
       final String key = await encryptedData.getString('key');

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id': key,
        }),
      );
      print(response.body);
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

  Future<int> deleteProduct(String id) async {
    const phpEndPoint = "https://georges-kalouch.000webhostapp.com/deleteProductFromCart.php";
       final String key = await encryptedData.getString('key');

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id': id,
        }),
      );
      if (response.statusCode == 200) {

      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return 0;
    }
  }
  //remove item form cart method
  void removeItemFromCart(BuildContext context, String id) {
//show a dialog box to ask user to confirm to remove from cart
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Remove this item from your cart?"),
        actions: [
          //cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          //yes button
          MaterialButton(
            onPressed: () async{
              Navigator.pop(context);
              await deleteProduct(id);
              await getCartProduct();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  //user pressed pay
  void payButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Text("User has payed"),
      ),
    );
  }

  @override
  void initState() {
    getCartProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Cart Page"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          //cart list
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text("Your cart is empty.."))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      //get individual item in cart
                      final item = products[index];

                      //return as a cart tile UI
                      return ListTile(
                        title: Text(item['Name']),
                        subtitle: Text(item['Price']),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => removeItemFromCart(context, item['ID']),
                        ),
                      );
                    },
                  ),
          ),

          //pay button
          MyButton(
              onTap: () => payButtonPressed(context),
              child: const Text("PAY NOW"))
        ],
      ),
    );
  }
}
