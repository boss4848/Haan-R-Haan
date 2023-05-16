import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/viewmodels/auth_view_model.dart';
import 'package:haan_r_haan/src/widgets/input_box.dart';
import 'package:provider/provider.dart';
import '../../../constant/constant.dart';
import '../../services/auth_service.dart';
import '../../widgets/button.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  //login
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //sign up
  final _newEmailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newUsernameController = TextEditingController();
  final _newPhoneNumberController = TextEditingController();

  final double bottomSheetPadding = 40;

  Future<void> logIn(context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.logIn(
      _emailController.text,
      _passwordController.text,
      context,
    );
  }

  Future<void> signUp(context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.signUp(
      _newEmailController.text,
      _newPasswordController.text,
      _newUsernameController.text,
      _newPhoneNumberController.text,
      context,
    );
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
                      fontSize: 15,
                    ),
                  ),
                ),
                const Spacer(),
                _buildButtons(context),
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

  Padding _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Button(
            () => _login(),
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
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    if (_emailController.text != "") {
                      await AuthService()
                          .changePassword(_emailController.text)
                          .then((value) {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          title: "Please check your email for password reset",
                          confirmBtnText: "Ok",
                        );
                      });
                    } else {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        title: "Please enter your email for password reset",
                        confirmBtnText: "Ok",
                      );
                    }
                  },
                  child: const Text(
                    "Forgot password",
                    style: TextStyle(
                        color: greyBackgroundColor,
                        fontSize: 16,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
              const Spacer(),
              Button(
                () => logIn(context),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                InputBox(
                  controller: _newUsernameController,
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
                  controller: _newPhoneNumberController,
                  errorText: "",
                  label: "Phone number (optional)",
                  isShadow: true,
                  isLight: true,
                ),
                const Spacer(),
                Button(() => signUp(context), "Sign up"),
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
