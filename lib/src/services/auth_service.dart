import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> changePassword(String? email) async {
    await _auth.sendPasswordResetEmail(
      email: email == "" ? _auth.currentUser!.email! : email!,
    );
  }

  Future<User?> signUp({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      // Sign up the user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Get the user's unique ID (uid)
      String uid = userCredential.user!.uid;
      // Store the user's data in Firestore
      UserModel user = UserModel(
        uid: uid,
        email: email,
        friendList: [], // Initialize with an empty list or actual friendList
        history: [], // Initialize with an empty list or actual history
        phoneNumber: phoneNumber,
        username: username,
        userTotalDebt: 0.0,
        userTotalLent: 0.0,
      );
      await _firestore.collection('users').doc(uid).set(user.toFirestore());
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
