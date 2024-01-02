import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:project2/Components/my_list_tile.dart';
import 'package:project2/Login.dart';
import 'package:project2/into_page.dart';

EncryptedSharedPreferences encryptedData = EncryptedSharedPreferences();


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Column(
           children: [
           //drawer header logo
           DrawerHeader(
             child: Center(
               child: Icon(
                 Icons.shopping_bag,
                 size: 72,
                 color: Theme.of(context).colorScheme.inversePrimary,
               ),
             ),
           ),

           const SizedBox(height: 25),

           //shop tile
           MyListTile(
             text: "Shop",
             icon: Icons.home,
             onTap: () => Navigator.pop(context),
           ),



          //cart tile
          MyListTile(
            text: "Cart",
            icon: Icons.shopping_cart,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cart_page');
             },
            ),
          ]),
        
          //exit shop tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              text: "Exit",
              icon: Icons.logout,
              onTap: ()async {
                encryptedData.clear();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>Login()));
              }
            ),
          ),
        ],
      ),
    );
  }
}
