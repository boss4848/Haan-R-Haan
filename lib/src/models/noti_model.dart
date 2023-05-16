import 'package:cloud_firestore/cloud_firestore.dart';

class NotiModel {
  String title;
  String body;
  String notiId;
  String sender;
  String receiver;
  String type;
  bool notified;
  Timestamp createdAt;
  List<String> combinedID = [];

  NotiModel({
    required this.title,
    required this.body,
    required this.notiId,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    this.type = '',
    required this.notified,
    required this.combinedID,
  });

  factory NotiModel.fromFirestore(DocumentSnapshot document) {
    return NotiModel(
      title: document['title'],
      body: document['body'],
      notiId: document['notiId'],
      sender: document['sender'],
      receiver: document['receiver'],
      createdAt: document['createdAt'],
      type: document['type'],
      notified: document['notified'],
      combinedID: document['combinedID'].cast<String>(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'notiId': notiId,
      'sender': sender,
      'receiver': receiver,
      'createdAt': createdAt,
      'type': type,
      'notified': notified,
      'combinedID': combinedID,
    };
  }
}
