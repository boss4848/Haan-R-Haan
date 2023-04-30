import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/login/widgets/button.dart';
import 'package:haan_r_haan/src/pages/select_food/widgets/member.dart';
import 'package:haan_r_haan/src/pages/select_member/widgets/button_outlined.dart';
import 'package:haan_r_haan/src/pages/select_member/widgets/member_item.dart';
import 'package:haan_r_haan/src/widgets/input_box.dart';
import 'package:haan_r_haan/src/widgets/title.dart';
import '../../../constant/constant.dart';
import 'package:intl/intl.dart';

import 'widgets/food_item.dart';

class SelectFoodPage extends StatefulWidget {
  const SelectFoodPage({super.key});

  @override
  State<SelectFoodPage> createState() => _SelectFoodPageState();
}

class _SelectFoodPageState extends State<SelectFoodPage> {
  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('EEE dd MMM HH:mm');
    return formatter.format(dateTime);
  }

  List<String> friends = [
    "John",
    "Doe",
    "Mark",
    "Zuckerberg",
    "Elon",
    "Musk",
    "Bill",
    "Gates",
    "Steve",
    "Jobs",
    "Jeff",
  ];

  List<bool> selectedFriends = List.filled(11, false);
  final foodNameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildContent(context),
          _buildBanner(context),
        ],
      ),
    );
  }

  Stack _buildBanner(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 85),
          decoration: const BoxDecoration(
            gradient: kDefaultBG,
          ),
          height: 170,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Party name",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Owner name",
                            style: TextStyle(
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            formatDateTime(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: boxShadow_1,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: greyBackgroundColor,
                  ),
                  child: const Text(
                    "Desctiption",
                    style: TextStyle(
                      fontSize: 19,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildStatus(
                        context: context,
                        sub: "SELECTED",
                        value: 10,
                        unit: "people",
                      ),
                      Container(
                        width: 1.2,
                        height: 50,
                        color: greyBackgroundColor,
                      ),
                      _buildStatus(
                        context: context,
                        sub: "JOIN BY LINK",
                        value: 20,
                        unit: "Members",
                      ),
                      Container(
                        width: 1.2,
                        height: 50,
                        color: greyBackgroundColor,
                      ),
                      _buildStatus(
                        context: context,
                        sub: "ADDED",
                        value: 2,
                        unit: "Foods",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Container _buildContent(BuildContext context) {
    return Container(
      color: blueBackgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 280),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: InputBox(
                      label: "Food name",
                      controller: foodNameController,
                      errorText: "errorText",
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: InputBox(
                      label: "Price",
                      controller: priceController,
                      errorText: "err",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(80, 50),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Add"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Who ate this food?",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  MemberItem(name: "Passakorn"),
                  MemberItem(name: "Boss"),
                  MemberItem(name: "Yo"),
                  MemberItem(name: "Dol"),
                  MemberItem(name: "Fahsai"),
                  MemberItem(name: "Gift"),
                  MemberItem(name: "Oil"),
                  MemberItem(name: "Mark"),
                  MemberItem(name: "Thanyakan"),
                  MemberItem(name: "Vatcharamai"),
                  MemberItem(name: "Patthadol"),
                  SizedBox(
                    width: double.infinity,
                    child: MemberItem(
                      name: "Select all",
                    ),
                  ),
                ],
              ),
              const TitleBar(
                title: "Food List",
                subTitle: "3 items",
                isNoPadding: true,
              ),
              const SizedBox(height: 10),
              const FoodItem(),
              const SizedBox(height: 10),
              const FoodItem(),
              const SizedBox(height: 10),
              const FoodItem(),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Button(() {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, "Create Party"),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildStatus({
    required BuildContext context,
    required String sub,
    required int value,
    required String unit,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 19,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$value",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(width: 5),
                Text(
                  unit,
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 13,
                  ),
                )
              ],
            ),
            const SizedBox(height: 3),
            Text(
              sub.toUpperCase(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
