import 'package:flutter/material.dart';

final theme = ThemeData(
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: kSecondaryColor,
      fontFamily: 'SFTHONBURI',
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      color: kSecondaryColor,
      fontFamily: 'SFTHONBURI',
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      color: kSecondaryColor,
      fontFamily: 'SFTHONBURI',
      fontWeight: FontWeight.w400,
    ),

    //Fixed font size
    bodyLarge: TextStyle(
      color: kPrimaryColor,
      fontFamily: 'SFTHONBURI',
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      color: kPrimaryColor,
      fontFamily: 'SFTHONBURI',
      fontSize: 19,
    ),
    labelMedium: TextStyle(
      color: kPrimaryColor,
      fontFamily: 'SFTHONBURI',
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: kPrimaryColor,
      fontFamily: 'SFTHONBURI',
      fontSize: 13,
    ),
  ),
);
const kPrimaryColor = Color(0xFF232248);
const kSecondaryColor = Color(0xFFFFFFFF);
const kButtonColor = Color(0xFFF517CF0);
const kCompColor = Color(0xFFF8F8F8);
const kMemberCardColor = Color(0xFFF47C7C);
const blueBackgroundColor = Color(0xFFACB8CE);
const redPastelColor = Color(0xffF47C7C);
const greenPastelColor = Color(0xffA7D2A1);
const greyTextColor = Color(0xFF9898A8);
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

const greyBackgroundColor = Color(0xFFE9E9E9);
const errorColor = Color(0xFFE11831);
final boxShadow_1 = BoxDecoration(
  borderRadius: BorderRadius.circular(13),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 20,
      offset: const Offset(0, 5),
    ),
  ],
);
final boxShadow_2 = BoxDecoration(
  borderRadius: BorderRadius.circular(13),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 5),
    ),
  ],
);
