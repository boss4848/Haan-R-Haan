import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/profile/widgets/profileBody.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: blueBackgroundColor,
      body: SingleChildScrollView(child: profileBody()),
    );
  }
}
