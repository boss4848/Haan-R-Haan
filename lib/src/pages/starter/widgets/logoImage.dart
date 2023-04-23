import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RotatingImageWidget extends StatefulWidget {
  @override
  _RotatingImageWidgetState createState() => _RotatingImageWidgetState();
}

class _RotatingImageWidgetState extends State<RotatingImageWidget> {
  double _rotation = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (details) {
          Offset center = Offset(
            context.size!.width / 2,
            context.size!.height / 2,
          );

          double angle = (details.localPosition - center).direction;

          // Convert the angle to degrees
          double degrees = angle * 180 / pi;

          setState(() {
            _rotation = degrees;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          transform: Matrix4.rotationZ(_rotation * pi / 180),
          child: Image.asset(
            "assets/images/logoSD.png",
          ),
        ));
  }
}
