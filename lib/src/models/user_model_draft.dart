import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final List<String> friendList;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.friendList,
    required this.phoneNumber,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      friendList: List<String>.from(data['friendList'] ?? []),
    );
  }
}
