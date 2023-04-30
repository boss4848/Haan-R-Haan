import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';

class Member extends StatelessWidget {
  final String name;
  const Member({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: greenPastelColor,
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
