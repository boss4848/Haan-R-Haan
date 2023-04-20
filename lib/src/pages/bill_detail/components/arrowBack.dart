import 'package:flutter/material.dart';

import '../../starter/starter_page.dart';

class arrowBack extends StatefulWidget {
  const arrowBack({super.key});

  @override
  State<arrowBack> createState() => _arrowBackState();
}

class _arrowBackState extends State<arrowBack> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: IconButton(
        onPressed: (() {
          Navigator.pop(
            context,
          );
        }),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
