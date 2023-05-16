import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constant/constant.dart';
import '../../../models/user_model.dart';
import '../../../viewmodels/user_view_model.dart';
import '../../scan/scan_page.dart';

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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScanPage(),
                ),
              );
            },
            child: Container(
              height: appBarSize,
              width: appBarSize,
              decoration: boxShadow_1,
              child: const Center(
                child: Icon(CupertinoIcons.qrcode_viewfinder, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: appBarSize,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: boxShadow_1,
              child: Consumer<UserViewModel>(builder: (
                context,
                userViewModel,
                child,
              ) {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where(
                          'uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[0];
                      final UserModel user = UserModel.fromFirestore(
                        documentSnapshot,
                      );
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatus(
                            image: "assets/images/dept.png",
                            amount: user.userTotalDebt,
                            title: "TOTAL DEPT",
                          ),
                          const VerticalDivider(thickness: 1),
                          _buildStatus(
                            image: "assets/images/bitcoin.png",
                            amount: user.userTotalLent,
                            title: "TOTAL LENT",
                          ),
                        ],
                      );
                    });
              }),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildStatus(
      {required String title, required String image, double amount = 0}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(image),
            const SizedBox(width: 10),
            Text(
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
