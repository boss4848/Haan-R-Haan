import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/bill_detail/member_bill_detail/widgets/bBody2.dart';

import '../../../../constant/constant.dart';

class MemberBillDetail extends StatelessWidget {
  const MemberBillDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueBackgroundColor,
      body: Bmemberbody(),
    );
  }
}
