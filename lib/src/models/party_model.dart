import 'package:cloud_firestore/cloud_firestore.dart';
import 'food_model.dart';
import 'payment_model.dart';

class PartyModel {
  final String partyID;
  final String partyName;
  final String partyDesc;
  final List<FoodModel> foodList;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final double totalAmount;
  final double totalLent;
  final List<PaymentModel> paymentList;
  final int paidCount;
  final bool isDraft;
  final List<String> members;
  final String ownerID;
  final String ownerName;

  PartyModel({
    required this.partyID,
    required this.partyName,
    required this.partyDesc,
    required this.foodList,
    required this.createdAt,
    required this.updatedAt,
    required this.totalAmount,
    required this.totalLent,
    required this.paymentList,
    required this.paidCount,
    required this.isDraft,
    required this.members,
    required this.ownerID,
    required this.ownerName,
  });
  factory PartyModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    List<FoodModel> foodItems = [];
    if (json['foodList'] != null) {
      for (var item in json['foodList']) {
        foodItems.add(FoodModel.fromFirestore(item));
      }
    }
    List<PaymentModel> paymentItems = [];
    if (json['paymentList'] != null) {
      for (var item in json['paymentList']) {
        paymentItems.add(PaymentModel.fromFirestore(item));
      }
    }
    return PartyModel(
      partyID: json['partyID'] ?? '',
      partyName: json['partyName'] ?? '',
      partyDesc: json['partyDesc'] ?? '',
      foodList: foodItems,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      totalAmount: json['totalAmount']?.toDouble() ?? 0.0,
      totalLent: json['totalLent']?.toDouble() ?? 0.0,
      paymentList: paymentItems,
      paidCount: json['paidCount'] ?? 0,
      isDraft: json['isDraft'] ?? false,
      members: List<String>.from(json['members'] ?? []),
      ownerID: json['ownerID'] ?? '',
      ownerName: json['ownerName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'partyID': partyID,
      'partyName': partyName,
      'partyDesc': partyDesc,
      'foodList': foodList.map((item) => item.toFirestore()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'totalAmount': totalAmount,
      'totalLent': totalLent,
      'paymentList': paymentList.map((item) => item.toFirestore()).toList(),
      'paidCount': paidCount,
      'isDraft': isDraft,
      'members': members,
      'ownerID': ownerID,
      'ownerName': ownerName,
    };
  }
}
