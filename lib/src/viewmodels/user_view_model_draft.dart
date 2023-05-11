import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model_draft.dart';

class UserViewModel extends ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> get users => _users;
  String _userID = '';
  String get userID => _userID;
  List<String> _friendList = [];
  List<String> _friendRequests = [];

  UserModel? _currentUserData;
  UserModel? get currentUserData => _currentUserData;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  init() async {
    final currentUserId = await _firestore
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) => value.docs.first.id);
    await fetchUserData(currentUserId);
  }

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      print('doc: $doc');

      _currentUserData = UserModel.fromFirestore(doc);
      _userID = uid;
      notifyListeners();
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<List<UserModel>> searchUsersByUsername(String username) async {
    try {
      //filter friend and friend request
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: username)
          .where('username', isLessThanOrEqualTo: '$username\uf8ff')
          .get();

      List<UserModel> searchResults = querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();

      return searchResults;
    } catch (e) {
      // print(e);
      rethrow;
    }
  }
}
