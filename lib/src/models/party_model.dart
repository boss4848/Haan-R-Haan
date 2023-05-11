import 'package:cloud_firestore/cloud_firestore.dart';

class PartyModel {
  final String id;
  final String partyName;
  final String partyDesc;
  final String ownerId;
  final String ownerName;
  final String promptpay;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> members;
  final double totalAmount;
  final double totalLent;
  final bool isDraft;
  final List<Map<String, dynamic>> foods;
  final List<Map<String, dynamic>> payments;

  PartyModel({
    required this.ownerName,
    required this.id,
    required this.partyName,
    required this.partyDesc,
    required this.ownerId,
    required this.promptpay,
    required this.createdAt,
    required this.updatedAt,
    required this.members,
    required this.totalAmount,
    required this.totalLent,
    required this.isDraft,
    required this.foods,
    required this.payments,
  });

  factory PartyModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PartyModel(
      id: doc.id,
      partyName: data['partyName'],
      partyDesc: data['partyDesc'],
      ownerId: data['ownerID'],
      promptpay: data['promptpay'],
      ownerName: data['ownerName'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      members: List<String>.from(data['members']),
      totalAmount: data['totalAmount'].toDouble(),
      totalLent: data['totalLent'].toDouble(),
      isDraft: data['isDraft'],
      foods: List<Map<String, dynamic>>.from(data['foods']),
      payments: List<Map<String, dynamic>>.from(data['payments']),
    );
  }
}
