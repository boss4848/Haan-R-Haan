import 'package:flutter/material.dart';
import '../../constant/constant.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
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
    ;
  }
}
