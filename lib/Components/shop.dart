import 'package:flutter/cupertino.dart';
import 'package:project2/Components/product.dart';

class Shop extends ChangeNotifier {

  //Products for sale
  final List<Product> _shop = [
    //product 1
    Product(
      name: "Glasses",
      price: 45.30,
      description: "Premium quality glasses with carbon fiber frame",
      imagePath: 'assets/Glasses.png',
    ),
    //product 2
    Product(
      name: "Hoodie",
      price: 30.00,
      description: "Black hoodie made with the finest Cotton",
      imagePath: 'assets/Hoodie.png',
    ),
    //product 3
    Product(
      name: "Shoes",
      price: 124.00,
      description: "Black running shoes, very good for any outdoor activities",
      imagePath: 'assets/Shoes.png',
    ),
    //product 4
    Product(
      name: "Watch",
      price: 200.00,
      description: "Stainless steel high end black watch",
      imagePath: 'assets/Watch.png',
    ),
  ];

  //user cart
  List<Product> _cart = [];

  //get product list
  List<Product> get shop => _shop;

  //get user cart
  List<Product> get cart => _cart;


  //add item to cart
  void addToCart(Product item) {
    _cart.add(item);
    notifyListeners();
  }

  //remove item from cart
  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners();
  }
}