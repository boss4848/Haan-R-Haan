import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

// ignore: camel_case_types
class profileBody extends StatelessWidget {
  const profileBody({super.key});

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kDefaultBG),
      child: Column(
        children: [
          SizedBox(
            child: Image.asset('assets/images/Banner.gif'),
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          Text(
            'Username',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          ElevatedButton(onPressed: signOut, child: const Text("Sign out"))
        ],
      ),
    );
  }
}
