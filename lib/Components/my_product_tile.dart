import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project2/Components/product.dart';
import 'package:project2/Components/shop.dart';
import 'package:provider/provider.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:http/http.dart' as http;

EncryptedSharedPreferences encryptedData = EncryptedSharedPreferences();

class MyProductTile extends StatelessWidget {
  final Map<String, dynamic> product;

  const MyProductTile({
    super.key,
    required this.product,
  });

  //add to cart button pressed
  void addToCart(BuildContext context,String Pid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Add this item to your cart?"),
        actions: [
          //cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),

          //yes button
          MaterialButton(
            onPressed: () async{
              //pop dialog box
              Navigator.pop(context);
              await addToCartDb(Pid);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<int> addToCartDb(String Pid) async {
    const phpEndPoint = "https://georges-kalouch.000webhostapp.com/addToCart.php";
       final String key = await encryptedData.getString('key');

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'Uid':key,
          'Pid': Pid,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {

      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(25),
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // product image
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25),
                  width: double.infinity,
                  child: Image.network(product['Image']),
                ),
              ),

              const SizedBox(height: 25),

              //product name
              Text(
                product['Name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),

              //product description
              Text(
                product['Description'],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          //product price + add to cart button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //product price
              Text('\$' + product['Price']),

              //add to cart button
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  onPressed: () => addToCart(context,product['ID']),
                  icon: const Icon(Icons.add),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
