// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../../constant/constant.dart';

// ignore: camel_case_types
class foodListCard extends StatelessWidget {
  final String foodList;
  final double foodPrice;
  final List allMember;
  const foodListCard(
      {super.key,
      required this.foodList,
      required this.foodPrice,
      required this.allMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 400,
      height: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [kDefaultShadow],
          color: kCompColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
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
          SizedBox(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                children: List.generate(
                    allMember.length,
                    (index) => Row(
                          children: [
                            const SizedBox(
                              width: kDefaultPadding / 2,
                            ),
                            MemberCard(allMember: allMember[index]),
                          ],
                        )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final Map allMember;
  const MemberCard({super.key, required this.allMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7), color: kMemberCardColor),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 4),
        child: Text(
          allMember['name'],
          style: const TextStyle(
              color: kSecondaryColor,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w200),
        ),
      ),
    );
  }
}
