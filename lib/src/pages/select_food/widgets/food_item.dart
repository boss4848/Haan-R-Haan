import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';
import 'member.dart';

class FoodItem extends StatefulWidget {
  const FoodItem({super.key});

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Stack(
        children: [
          Container(
            decoration: boxShadow_2.copyWith(
              color: const Color(0xFF3B3A5C),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(20),
            child: const Icon(
              CupertinoIcons.trash_fill,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isSelected = !isSelected;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: boxShadow_2,
              padding: const EdgeInsets.all(20),
              margin: EdgeInsets.only(right: isSelected ? 60 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "เหล้าหอมๆ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(
                        "190 Baht",
                        style: TextStyle(
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
                    children: const [
                      Member(name: "Passakorn"),
                      Member(name: "Boss"),
                      Member(name: "Yo"),
                      Member(name: "Dol"),
                      Member(name: "Mark"),
                      Member(name: "Oil"),
                      Member(name: "Fahsai"),
                      Member(name: "Gift"),
                      Member(name: "Kai wa"),
                      Member(name: "Banana"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
