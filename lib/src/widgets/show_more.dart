import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class ShowMore extends StatelessWidget {
  const ShowMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        right: 20,
        top: 10,
      ),
      alignment: Alignment.centerRight,
      child: const Text(
        "Show more",
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 15,
        ),
      ),
    );
  }
}
