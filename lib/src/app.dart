import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';

import 'pages/auth/auth_page.dart';
import 'viewmodels/friend_view_model.dart';
import 'viewmodels/party_view_model.dart';
import 'viewmodels/user_view_model.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => FriendViewModel()),
        ChangeNotifierProvider(create: (_) => PartyViewModel()),
      ],
      child: MaterialApp(
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
      ),
    );
  }
}
