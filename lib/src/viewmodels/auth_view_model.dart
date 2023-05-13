import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/loading.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;

  AuthViewModel() {
    _authService.authStateChanges().listen((User? user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<void> logIn(
    String email,
    String password,
    context,
  ) async {
    loading(context);
    try {
      await _authService.signIn(
        email: email,
        password: password,
      );
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Error",
        text: e.toString(),
      );
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String username,
    String phoneNumber,
    context,
  ) async {
    loading(context);
    try {
      bool usernameTaken = await isUsernameTaken(username);
      if (usernameTaken) {
        // Handle the case when the username is already taken
        throw "Username $username is already exists";
      }
      await _authService.signUp(
        email: email,
        password: password,
        username: username,
        phoneNumber: phoneNumber,
      );

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Error",
        text: e.toString(),
      );
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    final result = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    currentUser = null;
  }
}
