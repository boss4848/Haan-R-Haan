import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF232248);
const kSecondaryColor = Color(0xFFFFFFFF);
const kButtonColor = Color(0xFFF517CF0);
const kCompColor = Color(0xFFF8F8F8);
const kMemberCardColor = Color(0xFFD39494);
const blueBackgroundColor = Color(0xFFACB8CE);

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

const Description =
    'Split expenses with ease! Our app simplifies cost calculation for shared items among friends.';
