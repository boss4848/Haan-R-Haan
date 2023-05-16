import 'package:cloud_firestore/cloud_firestore.dart';
import 'food_model.dart';
import 'payment_model.dart';

class PartyModel {
  final String partyID;
  final String partyName;
  final String partyDesc;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final double totalAmount;
  final double totalLent;
  // final List<FoodModel> foodList;
  // final List<PaymentModel> paymentList;
  final List<Map<String, dynamic>> foodList;
  final List<Map<String, dynamic>> paymentList;
  final int paidCount;
  final bool isDraft;
  final List<String> members;
  final String ownerID;
  final String ownerName;
  final String promptpay;
  final List<String> membersJoinedByLink;

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
    required this.promptpay,
    required this.membersJoinedByLink,
  });
  factory PartyModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // print("foodList: ${data['foodList']}");
    // print("paymentList: ${data['paymentList']}");
    return PartyModel(
      partyID: data['partyID'] ?? '',
      partyName: data['partyName'] ?? '',
      partyDesc: data['partyDesc'] ?? '',
      ownerID: data['ownerID'] ?? '',
      promptpay: data['promptpay'] ?? '',
      ownerName: data['ownerName'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      members: List<String>.from(data['members']),
      totalAmount: data['totalAmount'].toDouble() ?? 0.0,
      totalLent: data['totalLent'].toDouble() ?? 0.0,
      isDraft: data['isDraft'] ?? true,
      paidCount: data['paidCount'] ?? 0,
      // foodList: [],
      // paymentList: [],
      foodList: List<Map<String, dynamic>>.from(data['foodList']),
      paymentList: List<Map<String, dynamic>>.from(data['paymentList']),
      membersJoinedByLink: List<String>.from(data['membersJoinedByLink']),
      // foodList: List<FoodModel>.from(
      //   data['foodList']
      //           .map((item) => FoodModel.fromFirestore(item))
      //           .toList() ??
      //       [],
      // ),
      // paymentList: List<PaymentModel>.from(
      //   data['paymentList']
      //           .map((item) => PaymentModel.fromFirestore(item))
      //           .toList() ??
      //       [],
      // ),
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'partyID': partyID,
      'partyName': partyName,
      'partyDesc': partyDesc,
      'foodList': foodList,
      // 'foodList': foodList.map((item) => item.toFirestore()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'totalAmount': totalAmount,
      'totalLent': totalLent,
      'paymentList': paymentList,
      // 'paymentList': paymentList.map((item) => item.toFirestore()).toList(),
      'paidCount': paidCount,
      'isDraft': isDraft,
      'members': members,
      'ownerID': ownerID,
      'ownerName': ownerName,
      'promptpay': promptpay,
      'membersJoinedByLink': membersJoinedByLink,
    };
  }
}
