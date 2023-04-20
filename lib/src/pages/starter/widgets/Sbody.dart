import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/starter/widgets/navButton.dart';

import '../../../../constant/constant.dart';

class SBody extends StatelessWidget {
  const SBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: kDefaultBG),
      child: Column(
        children: [
          SizedBox(
            height: 150,
          ),
          Container(
            width: double.infinity,
            height: 250,
            child: Image.asset(
              "assets/images/logoSD.png",
            ),
          ),
          SizedBox(
            height: 45,
          ),
          Text(
            'Haan R Haan',
            style: TextStyle(
                color: Colors.white, fontSize: 42, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 300,
            child: const Text(
              Description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 70,
          ),
          NavButton(),
        ],
      ),
    );
  }
}
