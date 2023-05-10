import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/services/notification_service.dart';
import 'package:haan_r_haan/src/viewmodels/auth_view_model.dart';
import 'package:haan_r_haan/src/viewmodels/friend_view_model.dart';
import 'package:haan_r_haan/src/viewmodels/party_view_model.dart';
import 'package:haan_r_haan/src/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

import 'pages/auth/auth_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(
          create: (context) => FriendViewModel(
            NotificationService(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => PartyViewModel()),
      ],
      child: MaterialApp(
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
      ),
    );
  }
}
