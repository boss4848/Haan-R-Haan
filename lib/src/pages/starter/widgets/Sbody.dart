import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/starter/widgets/logoImage.dart';
import 'package:haan_r_haan/src/pages/starter/widgets/navButton.dart';

import '../../../../constant/constant.dart';

class SBody extends StatelessWidget {
  const SBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: kDefaultBG),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 150),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.asset(
                "assets/images/logoSD.png",
              ),
            ),
            const Text(
              'Haan R Haan',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: 300,
              child: Text(
                Description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            const NavButton(),
          ],
        ),
      ),
    );
  }
}
