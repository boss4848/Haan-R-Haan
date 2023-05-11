import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            decoration: boxShadow_1,
            child: const Center(
              child: Icon(CupertinoIcons.qrcode_viewfinder, size: 40),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: appBarSize,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: boxShadow_1,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where('email',
                          isEqualTo: FirebaseAuth.instance.currentUser!.email)
                      .snapshots()
                      .map(
                        (event) => event.docs.first.data(),
                      ),
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatus(
                          image: "assets/images/dept.png",
                          amount: snapshot.data!["sumTotalDebt"] ?? 0.0,
                          title: "TOTAL DEBT",
                        ),
                        const VerticalDivider(thickness: 1),
                        _buildStatus(
                          image: "assets/images/bitcoin.png",
                          amount: snapshot.data!["sumTotalLent"] ?? 0.0,
                          title: "TOTAL LENT",
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildStatus({
    required String title,
    required String image,
    double amount = 0,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(image),
            const SizedBox(width: 10),
            Text(
              //fix 2 decimal
              "${amount.toStringAsFixed(0)} ฿",
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
