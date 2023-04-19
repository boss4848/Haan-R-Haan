import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF232248);
const kSecondaryColor = Color(0xFFFFFFFF);
const kButtonColor = Color(0xFF517CF0);

const kDefaultPadding = 20.0;

const kDefaultBG = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  stops: [0.1, 0.5, 0.4, 1.5],
  colors: [
    Color.fromARGB(255, 61, 60, 104),
    Color(0xFF232248),
    Color(0xFF232248),
    Color.fromARGB(255, 47, 46, 81),
  ],
);

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 4,
  color: Colors.black26,
);
