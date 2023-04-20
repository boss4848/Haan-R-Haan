import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';
import '../../../models/mockup_data.dart';
import 'foodListCard.dart';

class FoodList extends StatelessWidget {
  final Party party;
  const FoodList({
    super.key,
    required this.party,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                'Food List',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'SFTHONBURI',
                    fontWeight: FontWeight.w600),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: kDefaultPadding / 4, bottom: kDefaultPadding / 2),
                child: Column(
                  children: List.generate(
                    party.foodName.length * 10,
                    (index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: foodListCard(
                        foodList: "foodname",
                        foodPrice: 10,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total : ' + '${party.totalPrice.toStringAsFixed(2)}฿',
                  // textAlign: TextAlign.right,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
