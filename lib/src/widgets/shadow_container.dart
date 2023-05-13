import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class ShadowContainer extends StatelessWidget {
  final List<Widget> list;
  final bool showMoreIcon;

  const ShadowContainer({
    required this.list,
    this.showMoreIcon = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 10,
      ),
      decoration: boxShadow_1,
      child: Column(children: list),
    );
  }
}
