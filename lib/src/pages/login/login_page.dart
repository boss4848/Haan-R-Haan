import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/login/widgets/button.dart';
import 'package:haan_r_haan/src/pages/login/widgets/input_field.dart';

import '../sign_up/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();
  var _errorMessage = "";

  Future<void> logIn() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = "* ${e.message}";
      });
      print(e.code);
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("building: Login page");
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
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 250,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Welcome to haan R Haan!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Log in",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
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
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.amber),
              ),
              const SizedBox(height: 20),
              Button(logIn, "Log in"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const SignUpPage();
                        },
                      ));
                    },
                    child: const Text("Sign up"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Forget password"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
