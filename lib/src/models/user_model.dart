import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final List<String> friendList;
  final List<History> history;
  final String phoneNumber;
  final String username;
  final double userTotalDebt;
  final double userTotalLent;

  UserModel({
    required this.uid,
    required this.email,
    required this.friendList,
    required this.history,
    required this.phoneNumber,
    required this.username,
    required this.userTotalDebt,
    required this.userTotalLent,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;

    List<History> historyItems = [];
    if (json['history'] != null) {
      for (var item in json['history']) {
        historyItems.add(History.fromFirestore(item));
      }
    }

    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      friendList: List<String>.from(json['friendList'] ?? []),
      history: historyItems,
      phoneNumber: json['phoneNumber'] ?? '',
      username: json['username'] ?? '',
      userTotalDebt: json['userTotalDebt']?.toDouble() ?? 0.0,
      userTotalLent: json['userTotalLent']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'friendList': friendList,
      'history': history.map((item) => item.toFirestore()).toList(),
      'phoneNumber': phoneNumber,
      'username': username,
      'userTotalDebt': userTotalDebt,
      'userTotalLent': userTotalLent,
    };
  }

  UserModel.empty()
      : uid = '',
        email = '',
        friendList = [],
        history = [],
        phoneNumber = '',
        username = '',
        userTotalDebt = 0.0,
        userTotalLent = 0.0;
}

class History {
  final String title;
  final String message;
  final Timestamp timestamp;
  final String type;
  History({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
  });

  factory History.fromFirestore(Map<String, dynamic> json) {
    return History(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] as Timestamp,
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'message': message,
      'timestamp': timestamp,
      'type': type,
    };
  }
}
