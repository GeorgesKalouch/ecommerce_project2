import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project2/Login.dart';
import 'package:http/http.dart' as http;


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String error = '';
  final _formKey = GlobalKey<FormState>();

  Future<int> register(String name,String email,String password) async {
    const phpEndPoint = "https://georges-kalouch.000webhostapp.com/register.php";

    try {
      final response = await http.post(
        Uri.parse(phpEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'password': password,
          'email': email,
        }),
      );
      print(response.body);
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
            'Register',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.9,
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black,
            ),
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
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
                        if (!value
                            .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                          return 'Password must contain at least one special character';
                        }

                        // If the password meets all criteria, return null (no error)
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }

                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }

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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String name = _nameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;

                          final response = await register(name,email,password);
                          if(response==200){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>Login()));
                          }
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.black),
                      ),
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
            Text("Already have an account",
                style: TextStyle(
                  color: Colors.black,
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (builder) => Login()));
                },
                child: Text("Login",
                    style: TextStyle(
                      color: Colors.black,
                    )))
          ],
        ));
  }
}
