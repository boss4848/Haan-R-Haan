import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

import 'pages/auth/auth_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white,
            ),
            headlineLarge: TextStyle(
                color: kSecondaryColor,
                fontFamily: 'SFTHONBURI',
                fontWeight: FontWeight.w700),
            headlineMedium: TextStyle(
                color: kSecondaryColor,
                fontFamily: 'SFTHONBURI',
                fontWeight: FontWeight.w600),
            headlineSmall: TextStyle(
                color: kSecondaryColor,
                fontFamily: 'SFTHONBURI',
                fontWeight: FontWeight.w400)),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
