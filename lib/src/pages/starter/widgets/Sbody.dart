import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/starter/widgets/logoImage.dart';
import 'package:haan_r_haan/src/pages/starter/widgets/navButton.dart';

import '../../../../constant/constant.dart';

class SBody extends StatelessWidget {
  const SBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 350,
                    height: 350,
                    child: Image.asset(
                      "assets/images/profile_image.jpg",
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Image.asset(
                      "assets/images/logoSD.png",
                    ),
                  ),
                ],
              ),
              Text('Welcome to',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(
                height: kDefaultPadding / 3,
              ),
              SizedBox(
                child: Image.asset(
                  "assets/images/nameBanner4.png",
                ),
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              const SizedBox(
                width: 300,
                child: Text(
                  Description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              const NavButton(),
            ],
          ),
        ),
      ),
    );
  }
}
