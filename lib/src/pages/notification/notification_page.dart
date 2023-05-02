import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/bill_detail/owner_bill_detail/widgets/arrowBack.dart';
import 'package:haan_r_haan/src/pages/notification/widget/noti_addfriend.dart';
import 'package:haan_r_haan/src/pages/notification/widget/noti_billpaid.dart';
import 'package:haan_r_haan/src/pages/notification/widget/noti_debt.dart';
import 'package:haan_r_haan/src/pages/notification/widget/noti_group.dart';
import 'package:haan_r_haan/src/pages/notification/widget/noti_overdued.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

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
          children: [
            const SizedBox(height: 160),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Wrap(
                runSpacing: 10,
                children: const [
                  NotiFriend(name: "Boss", time: "Tue 18 Apr 22:26"),
                  NotiGroup(name: "Gift", time: "Tue 18 Apr 22:26", partyName: "Party name",),
                  NotiOverdued(
                      partyName: "GuGu chicken",
                      money: "1,000",
                      time: "Tue 18 Apr 22:26"),
                  NotiDebt(partyNumber: "3", money: "190", time: "Tue 18 Apr 22:26"),
                  NotiBillPaid(partyName: "Party name", money: "100", time: "Tue 18 Apr 22:26", name: "Boss")
                ],
              ),
            )
          ],
        ),
        ),
      ),
    );
  }

  Container _buildBanner(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: kDefaultBG,
      ),
      height: 140,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Row(
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
              const Text(
                "Create Party",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
