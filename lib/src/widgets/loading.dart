import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

Future loading(BuildContext context) {
  return showDialog(
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    builder: (context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logoloading.gif",
              width: 100,
            ),
            const SizedBox(height: 10),
            const Text(
              'Loading...',
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      );
    },
  );
}
