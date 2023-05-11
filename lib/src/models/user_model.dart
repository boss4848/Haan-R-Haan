import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final List<String> friendList;
  final List<History> history;
  final String phoneNumber;
  final String username;

  UserModel({
    required this.uid,
    required this.email,
    required this.friendList,
    required this.history,
    required this.phoneNumber,
    required this.username,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    List<History> historyItems = [];
    for (var item in json['history']) {
      historyItems.add(History.fromFirestore(item));
    }

    return UserModel(
      uid: json['uid'],
      email: json['email'],
      friendList: List<String>.from(json['friendList']),
      history: historyItems,
      phoneNumber: json['phoneNumber'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'friendList': friendList,
      'history': history.map((item) => item.toJson()).toList(),
      'phoneNumber': phoneNumber,
      'username': username,
    };
  }

  UserModel.empty()
      : uid = '',
        email = '',
        friendList = [],
        history = [],
        phoneNumber = '',
        username = '';
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
      title: json['title'],
      message: json['message'],
      timestamp: json['timestamp'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'timestamp': timestamp,
      'type': type,
    };
  }
}
