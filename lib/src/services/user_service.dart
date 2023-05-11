import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserId() async {
    final currentUserId = await _firestore
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser?.email)
        .get()
        .then((value) => value.docs.first.id);
    return currentUserId;
  }

  Future<UserModel> fetchUser(String userId) async {
    DocumentSnapshot doc = await _firestore
        .collection(
          'users',
        )
        .doc(userId)
        .get();
    return UserModel.fromFirestore(
      doc.data() as Map<String, dynamic>,
    );
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(user.toFirestore());
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}
