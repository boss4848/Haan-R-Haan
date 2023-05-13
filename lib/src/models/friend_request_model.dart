import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  final String id;
  final String senderID;
  final String receiverID;
  final List<String> combinedID;
  final Timestamp timestamp;
  final bool status;

  FriendRequestModel({
    required this.id,
    required this.senderID,
    required this.receiverID,
    required this.combinedID,
    required this.timestamp,
    required this.status,
  });

  factory FriendRequestModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FriendRequestModel(
      id: doc.id,
      senderID: data['senderID'],
      receiverID: data['receiverID'],
      combinedID: data['combinedID'].cast<String>(),
      timestamp: (data['timestamp'] as Timestamp),
      status: data['status'],
    );
  }
}
