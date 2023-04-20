import 'package:flutter/material.dart';
import '../../../../constant/constant.dart';
import '../../../models/mockup_data.dart';

class foodListCard extends StatelessWidget {
  final String foodList;
  final double foodPrice;
  const foodListCard(
      {super.key, required this.foodList, required this.foodPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 400,
      height: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [kDefaultShadow],
          color: kCompColor),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Text(foodList,
              style: const TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'Kanit',
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(
            '${foodPrice.toStringAsFixed(2)}฿',
            style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}