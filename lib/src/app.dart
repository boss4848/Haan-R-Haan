import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

import 'pages/auth/auth_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: kButtonColor,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
    );

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: kSecondaryColor,
      backgroundColor: kButtonColor,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shadowColor: Colors.black,
      elevation: 15,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );

    final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: kSecondaryColor,
      minimumSize: Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    ).copyWith(
      side: MaterialStateProperty.resolveWith<BorderSide>(
        (Set<MaterialState> states) => states.contains(MaterialState.pressed)
            ? BorderSide(
                color: Theme.of(context as BuildContext).colorScheme.primary,
                width: 2,
              )
            : const BorderSide(
                color: Colors.white, // Change color to white
                width: 1),
      ),
    );
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white,
            ),
            headlineLarge: TextStyle(
                color: kSecondaryColor,
                fontSize: 40,
                fontFamily: 'SFTHONBURI',
                fontWeight: FontWeight.w700),
            headlineMedium: TextStyle(
                color: kSecondaryColor,
                fontSize: 20,
                fontFamily: 'SFTHONBURI',
                fontWeight: FontWeight.w600),
            headlineSmall: TextStyle(
                //text in button must be use
                color: kSecondaryColor,
                fontSize: 16,
                fontFamily: 'SFTHONBURI',
                fontWeight: FontWeight.w700),
            bodySmall: TextStyle(
                color: kSecondaryColor,
                fontSize: 14,
                fontFamily: 'SFTHONBURI',
                fontWeight: FontWeight.w400)),
        textButtonTheme: TextButtonThemeData(style: flatButtonStyle),
        elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
