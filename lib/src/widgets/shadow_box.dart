import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class ShadowBox extends StatelessWidget {
  final List<Widget> element;
  final bool showMoreIcon;

  const ShadowBox({
    required this.element,
    this.showMoreIcon = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return element.isNotEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 10,
            ),
            decoration: boxShadow_1,
            child: Column(
              children: element,
            ),
          )
        : const SizedBox();
  }
}
