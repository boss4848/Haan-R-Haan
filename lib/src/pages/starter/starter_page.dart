import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/login/widgets/button.dart';
import 'package:haan_r_haan/src/widgets/input_box.dart';

import '../../../constant/constant.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  //login and sign up
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorLoginMessage = "";

  //sign up
  final _newEmailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  String _errorSignUpMessage = "";

  final double bottomSheetPadding = 40;
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
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      final errorMessage = "* ${e.message}";
      print(e.code);
      Navigator.pop(context);
      setState(() {
        _errorLoginMessage = errorMessage;
      });
      CoolAlert.show(
        backgroundColor: redPastelColor,
        context: context,
        type: CoolAlertType.error,
        text: _errorLoginMessage,
      );
    }
  }

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
        email: _newEmailController.text,
        password: _newPasswordController.text,
      );
      addUserDetails();
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorSignUpMessage = "* ${e.message}";
      });
      print(e.code);
      Navigator.pop(context);
      CoolAlert.show(
        backgroundColor: redPastelColor,
        context: context,
        type: CoolAlertType.error,
        text: _errorSignUpMessage,
      );
    }
  }

  addUserDetails() async {
    await FirebaseFirestore.instance.collection("users").add({
      "username": _usernameController.text,
      "email": _emailController.text,
      "phoneNumber": _phoneNumberController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: kDefaultBG,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  "assets/images/logo.png",
                  height: 240,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  "assets/images/nameBanner4.png",
                  height: 80,
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 300,
                  child: Text(
                    "Split expenses with ease! \n Our app simplifies cost calculation \n for shared items among friends.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 18,
                    ),
                  ),
                ),
                const Spacer(),
                _buildButton(context),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Button(
            () {
              _login();
            },
            "Login",
            isOutlined: true,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 0.3,
                  color: const Color(0xFFCCCCCC),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "or",
                style: TextStyle(
                  color: Color(0xFFCCCCCC),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 0.3,
                  color: const Color(0xFFCCCCCC),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Button(() {
            _signUp();
          }, "Sign up"),
        ],
      ),
    );
  }

  _login() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: blueBackgroundColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            gradient: kDefaultBG,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: bottomSheetPadding,
            vertical: 20,
          ),
          // height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // const Text(
              //   "Login",
              //   style: TextStyle(
              //     color: kPrimaryColor,
              //     fontSize: 32,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              InputBox(
                controller: _emailController,
                errorText: "",
                label: "Username or email",
                isShadow: true,
                isLight: true,
              ),
              InputBox(
                controller: _passwordController,
                errorText: "",
                label: "Password",
                isShadow: true,
                isLight: true,
                obscureText: true,
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot password",
                  style: TextStyle(
                      color: greyBackgroundColor,
                      fontSize: 16,
                      decoration: TextDecoration.underline),
                ),
              ),
              const Spacer(),
              Button(
                logIn,
                "Login",
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        );
      },
    );
  }

  _signUp() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: blueBackgroundColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              gradient: kDefaultBG,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: bottomSheetPadding,
              vertical: 20,
            ),
            // height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        CupertinoIcons.back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // const Text(
                //   "Sign Up",
                //   style: TextStyle(
                //     color: kPrimaryColor,
                //     fontSize: 32,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                InputBox(
                  controller: _usernameController,
                  errorText: "",
                  label: "Username",
                  isShadow: true,
                  isLight: true,
                ),
                InputBox(
                  controller: _newPasswordController,
                  errorText: "",
                  label: "Password",
                  obscureText: true,
                  isShadow: true,
                  isLight: true,
                ),
                InputBox(
                  controller: _newEmailController,
                  errorText: "",
                  label: "Email",
                  isShadow: true,
                  isLight: true,
                ),
                InputBox(
                  controller: _phoneNumberController,
                  errorText: "",
                  label: "Phone number (optional)",
                  isShadow: true,
                  isLight: true,
                ),
                const Spacer(),
                Button(
                  signUp,
                  "Sign up",
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
