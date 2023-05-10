import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

class ScanRabert extends StatelessWidget {
  const ScanRabert({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Raberd());
  }
}

class Raberd extends StatelessWidget {
  const Raberd({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      color: kPrimaryColor,
      child: Center(
        child: Text(
          "scanPage ทำแอประเบิดขอใช้หน้านี้ก่อน",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
