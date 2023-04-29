import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class ShadowContainer extends StatelessWidget {
  final Widget element;
  final int length;
  final bool showMoreIcon;

  const ShadowContainer({
    required this.length,
    required this.element,
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
      decoration: boxShadow,
      child: Column(
        children: [
          // loop through the list of widgets
          if (length > 0)
            for (var i = 0; i < length; i++) element,
          // show more icon
          if (showMoreIcon)
            const Icon(
              Icons.more_horiz,
              color: kPrimaryColor,
            ),
        ],
      ),
    );
  }
}
