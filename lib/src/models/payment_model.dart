import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final bool isPaid;
  // final String payerID;
  final double payment;

  PaymentModel({
    required this.id,
    required this.isPaid,
    // required this.payerID,
    required this.payment,
  });
  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return PaymentModel(
      id: json['id'] ?? '',
      isPaid: json['isPaid'] ?? false,
      // payerID: json['payerID'] ?? '',
      payment: json['payment']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'isPaid': isPaid,
      // 'payerID': payerID,
      'payment': payment,
    };
  }
}
