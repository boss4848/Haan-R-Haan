import 'package:haan_r_haan/src/models/user_model_draft.dart';

class FoodModel {
  String foodName;
  double foodPrice;
  List<UserModel> eaters;

  FoodModel({
    required this.foodName,
    required this.foodPrice,
    required this.eaters,
  });

  Map<String, dynamic> toJson() {
    return {
      "foodName": foodName,
      "foodPrice": foodPrice,
      "eaters": eaters.map((eater) => eater.id).toList(),
    };
  }
}
