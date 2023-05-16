import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  final String foodName;
  final double foodPrice;
  final List<String> eaters;

  FoodModel({
    required this.foodName,
    required this.foodPrice,
    required this.eaters,
  });

  factory FoodModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;

    // List<String> eaters = [];
    // if (json['eaters'] != null) {
    //   for (var item in json['eaters']) {
    //     eaters.add(UserModel.fromFirestore(item));
    //   }
    // }

    return FoodModel(
      foodName: json['foodName'] ?? '',
      foodPrice: json['foodPrice']?.toDouble() ?? 0.0,
      eaters: json['eaters'] ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'foodName': foodName,
      'foodPrice': foodPrice,
      'eaters': eaters,
      // "eaters": eaters.map((eater) => eater).toList(),
    };
  }
}
