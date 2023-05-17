import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/bill_detail/owner_bill_detail/widgets/arrowBack.dart';

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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.maxFinite,
        color: kPrimaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                alignment: Alignment.centerLeft,
                child: const arrowBack(),
              ),
              Text(
                "scanPage ทำแอประเบิดขอใช้หน้านี้ก่อน",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
