import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constant/constant.dart';
import '../login/widgets/button.dart';
import '../login/widgets/input_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  signUp() async {
    //Show loading
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      addUserDetails();
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = "* ${e.message}";
      });
      print(e.code);

      Navigator.pop(context);
    }
  }

  addUserDetails() async {
    await FirebaseFirestore.instance.collection("users").add({
      "username": _usernameController.text,
      "email": _emailController.text,
      "phoneNumber": _phoneNumberController.text,
    });
  }

  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    print("building: signup page");
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: kDefaultBG,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Create account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              InputField(
                _usernameController,
                "Username (optional)",
                false,
                // _validateEmail,
              ),
              const SizedBox(height: 10),
              InputField(
                _emailController,
                "Email",
                false,
                // _validateEmail,
              ),
              const SizedBox(height: 10),
              InputField(
                _passwordController,
                "Password",
                true,
                // _validateEmail,
              ),
              const SizedBox(height: 10),
              InputField(
                _phoneNumberController,
                "Phone number (optional)",
                false,
                // _validateEmail,
              ),
              const SizedBox(height: 10),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.amber),
              ),
              const SizedBox(height: 20),
              Button(signUp, "Sign up"),
            ],
          ),
        ),
      ),
    );
  }
}
