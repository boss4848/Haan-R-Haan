// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/bill_detail/owner_bill_detail/widgets/arrowBack.dart';
import '../../../../../constant/constant.dart';

class FoodListCard extends StatelessWidget {
  final String foodList;
  final double foodPrice;
  final List allMember;
  const FoodListCard({
    Key? key,
    required this.foodList,
    required this.foodPrice,
    required this.allMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [kDefaultShadow],
        color: kCompColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding, horizontal: kDefaultPadding / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: kDefaultPadding,
                ),
                Text(
                  foodList,
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontFamily: 'Kanit',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text('${foodPrice.toStringAsFixed(0)} Baht',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(
                  width: kDefaultPadding,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 2,
                  vertical: kDefaultPadding / 2),
              child: Container(
                width: double.maxFinite,
                child: Wrap(
                  runSpacing: 5,
                  spacing: 5,
                  children: List.generate(
                    allMember.length,
                    (index) => Wrap(
                      children: [
                        MemberCard(allMember: allMember[index]),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final Map allMember;
  const MemberCard({Key? key, required this.allMember}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: kMemberCardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding / 4, horizontal: kDefaultPadding / 1.5),
        child: Text(allMember['name'],
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: kSecondaryColor, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
