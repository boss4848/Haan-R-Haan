import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/profile/widgets/user_info.dart';

// ignore: camel_case_types
class profileBody extends StatelessWidget {
  const profileBody({super.key});

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(children: [
            const SizedBox(
                width: double.infinity,
                child: Image(
                  image: AssetImage('assets/images/Banner.gif'),
                  fit: BoxFit.cover,
                )),
            Container(
              margin: const EdgeInsets.only(left: 33, top: 65),
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/profile.jpg'),
                ),
              ),
            )
          ]),
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        UserInfoWidget(),
        ElevatedButton(onPressed: signOut, child: const Text("Sign out"))
      ],
    );
  }
}
