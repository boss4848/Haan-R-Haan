import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import './user_view_model_draft.dart';
import '../services/fcm_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> isUsernameTaken(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String username,
    // required UserViewModel userViewModel,
    String? phoneNumber,
  }) async {
    try {
      // Check if username is taken
      bool usernameTaken = await isUsernameTaken(username);
      if (usernameTaken) {
        // Handle the case when the username is already taken
        throw "Username $username is already exists";
      }
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // await userCredential.user!.updateDisplayName(username);
      await saveUserDetails(
        userCredential.user!.uid,
        email,
        username,
        phoneNumber,
      );

      // await userViewModel.fetchUserData(userCredential.user!.uid);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // print(e);
      return null;
    }
  }

  Future<void> saveUserDetails(
    String uid,
    String email,
    String username,
    String? phoneNumber,
  ) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Map<String, dynamic> userData = {
      'username': username,
      'email': email,
      'uid': uid,
    };

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      userData['phoneNumber'] = phoneNumber;
    }
    await users.doc(uid).set(userData);
  }

  // Future<bool> isUsernameTaken(String username) async {
  //   final result = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('username', isEqualTo: username)
  //       .limit(1)
  //       .get();
  //   return result.docs.isNotEmpty;
  // }

  // Future<UserCredential?> signUp({
  //   required String email,
  //   required String password,
  //   required String username,
  //   String? phoneNumber,
  //   required UserViewModel userViewModel,
  // }) async {
  //   try {
  //     // Check if username is taken
  //     bool usernameTaken = await isUsernameTaken(username);
  //     if (usernameTaken) {
  //       // Handle the case when the username is already taken
  //       throw "Username $username is already exists";
  //     }
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     await userCredential.user!.updateDisplayName(username);
  //     await saveUserDetails(
  //       userCredential.user!.uid,
  //       email,
  //       username,
  //       phoneNumber,
  //     );
  //     // Fetch user data after successful sign-up
  //     await userViewModel.fetchUserData(userCredential.user!.uid);

  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     // print(e);
  //     return null;
  //   }
  // }

  // Future<void> saveUserDetails(
  //   String uid,
  //   String email,
  //   String username,
  //   String? phoneNumber,
  // ) async {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   // String? fcmToken = await FCMService().getToken();
  //   Map<String, dynamic> userData = {
  //     'username': username,
  //     'email': email,
  //     'uid': uid,
  //     // 'fcmToken': fcmToken,
  //   };

  //   if (phoneNumber != null && phoneNumber.isNotEmpty) {
  //     userData['phoneNumber'] = phoneNumber;
  //   }
  //   await users.doc(uid).set(userData);
  // }

  Future<UserCredential?> login(
    String email,
    String password,
    UserViewModel userViewModel,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Fetch user data after successful login
      await userViewModel.fetchUserData(userCredential.user!.uid);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
