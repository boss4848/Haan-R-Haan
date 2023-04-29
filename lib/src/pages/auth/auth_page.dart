import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/login/login_page.dart';
import 'package:haan_r_haan/src/pages/starter/starter_page.dart';

import '../main/main_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // return const StartPage();
        // Logged in
        if (snapshot.hasData) {
          return const MainPage();
        }
        // Logged out
        else {
          return const LoginPage();
        }
      },
    );
  }
}
