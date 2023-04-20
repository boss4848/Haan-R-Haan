import 'package:flutter/material.dart';

import '../../../constant/constant.dart';
import 'components/Bbody.dart';

class BillDetailPage extends StatelessWidget {
  const BillDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Bbody(),
    );
  }
}
