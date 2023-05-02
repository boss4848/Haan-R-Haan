import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';
import 'widgets/Bbody.dart';

class OwnerBillDetailPage extends StatelessWidget {
  const OwnerBillDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueBackgroundColor,
      body: Bbody(),
    );
  }
}
