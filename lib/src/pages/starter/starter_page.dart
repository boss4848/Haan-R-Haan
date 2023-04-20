import 'package:flutter/material.dart';

import '../../../constant/constant.dart';
import 'widgets/Sbody.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SBody(),
    );
  }
}
