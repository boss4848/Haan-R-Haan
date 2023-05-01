import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

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
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class xBack extends StatefulWidget {
  const xBack({super.key});

  @override
  State<xBack> createState() => _xBackState();
}

class _xBackState extends State<xBack> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        onPressed: (() {
          Navigator.pop(
            context,
          );
        }),
        icon: const Icon(
          Icons.clear_rounded,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
