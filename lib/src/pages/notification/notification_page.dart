import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/bill_detail/components/arrowBack.dart';
import 'package:haan_r_haan/src/pages/notification/widget/noti_addfriend.dart';
import 'package:haan_r_haan/src/pages/notification/widget/noti_group.dart';
import 'package:haan_r_haan/src/pages/notification/widget/noti_overdued.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Row(
              children: const [
                arrowBack(),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Wrap(
                runSpacing: 10,
                children: const [
                  NotiFriend(name: "Yo", time: "19 Apr 09:59"),
                  NotiGroup(name: "Gift", time: "19 Apr 09:59"),
                  NotiOverdued(
                      partyName: "GuGu chicken",
                      money: "1,000",
                      time: "19 Apr 09:59")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
