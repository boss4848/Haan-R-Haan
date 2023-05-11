import 'package:flutter/cupertino.dart';
import 'package:haan_r_haan/src/models/user_model.dart';

import '../../../../constant/constant.dart';
import '../../select_food/widgets/member.dart';

class FoodItem extends StatelessWidget {
  final String foodName;
  final double foodPrice;
  final List<UserModel> eaters;
  const FoodItem(
      {super.key,
      required this.foodName,
      required this.foodPrice,
      required this.eaters});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxShadow_2,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                foodName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              Text(
                "$foodPrice Baht",
                style: const TextStyle(
                  fontSize: 16,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: List.generate(
              eaters.length,
              (index) {
                print(eaters[index].username);
                return Member(
                  name: eaters[index].username,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
