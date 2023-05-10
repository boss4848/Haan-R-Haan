import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_view_model.dart';
import '../main/main_page.dart';
import '../starter/starter_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        // Logged in
        if (authViewModel.currentUser != null) {
          return const MainPage();
        }
        // Logged out
        else {
          return const StartPage();
        }
      },
    );
  }
}
