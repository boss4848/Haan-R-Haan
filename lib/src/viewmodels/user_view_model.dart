import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late UserModel _user;
  UserModel get user => _user;

  UserViewModel() {
    _user = UserModel.empty();
  }

  Future<UserModel> fetchUser() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: _auth.currentUser!.email)
          .get()
          .then((value) => value.docs.first);
      _user = UserModel.fromFirestore(userDoc);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
    return _user;
  }

  Future<UserModel> fetchUserByID(String userID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(userID).get();
      _user = UserModel.fromFirestore(userDoc);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
    return _user;
  }
}
