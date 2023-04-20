import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/bill_detail/components/arrowBack.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Row(
        children: const [
          arrowBack(),
          Text("Notification"),
        ],
      ),
    );
  }
}
