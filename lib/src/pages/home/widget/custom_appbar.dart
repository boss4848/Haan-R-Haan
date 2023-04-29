import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});
  final double appBarSize = 65;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: appBarSize,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: appBarSize,
            width: appBarSize,
            decoration: boxShadow,
            child: const Center(
              child: Icon(CupertinoIcons.qrcode_viewfinder, size: 40),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: appBarSize,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: boxShadow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatus(
                    image: "assets/images/dept.png",
                    amount: 1100,
                    title: "TOTAL DEPT",
                  ),
                  const VerticalDivider(thickness: 1),
                  _buildStatus(
                    image: "assets/images/bitcoin.png",
                    amount: 1000,
                    title: "TOTAL LENT",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildStatus(
      {required String title, required String image, int amount = 0}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(image),
            const SizedBox(width: 10),
            Text(
              "$amount ฿",
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
