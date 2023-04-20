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
    return Column(
      children: [
        Text(
          'Food List',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'SFTHONBURI',
              fontWeight: FontWeight.w600),
        ),
        Container(
          margin: EdgeInsets.only(
              top: kDefaultPadding / 4, bottom: kDefaultPadding / 2),
          width: 370,
          child: Column(
            children: List.generate(
              party.foodName.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: foodListCard(
                  foodList: party.foodName[index],
                  foodPrice: party.foodPrice[index],
                ),
              ),
            ),
          ),
        ),
        Text(
          'Total : ' + '${party.totalPrice.toStringAsFixed(2)}฿',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
