import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project2/Register.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:project2/into_page.dart';

EncryptedSharedPreferences encryptedData = EncryptedSharedPreferences();


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  String error = '';
  final _formKey = GlobalKey<FormState>();

  Future<int> login(String email,String password) async {
    const phpEndPoint = "https://georges-kalouch.000webhostapp.com/login.php";

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Successful login
        Map<String, dynamic> userData = json.decode(response.body);
        print(userData);
        encryptedData.setString('key', userData['ID']);
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width / 1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailC,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Phone Number';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordC,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }

                      // Add your custom password validation logic here
                      if (value.length < 8) {
                        return 'Password must be at\n least 8 characters long';
                      }

                      // You can add more criteria, such as requiring at least one digit
                      if (!value.contains(RegExp(r'\d'))) {
                        return 'Password must contain at least one digit';
                      }

                      // You can add more criteria, such as requiring at least one special character
                      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'Password must contain at least one special character';
                      }

                      // If the password meets all criteria, return null (no error)
                      return null;
                    },
                  ),
                ),
                error != ''
                    ? Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      )
                    : Center(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async{
                      if (_formKey.currentState!.validate()) {
                        // Perform authentication logic here
                        String email = emailC.text;
                        String password = passwordC.text;
                        final response = await login(email, password);
                        if(response==200){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>IntroPage()));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(color: Colors.black),
                    ),
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Dont have an account?",style: TextStyle(color: Colors.white,) ),
          TextButton(onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>Register()));
          } , child: Text("Register",style: TextStyle(color: Colors.white,)))
        ],
      ),
    );
  }
}
