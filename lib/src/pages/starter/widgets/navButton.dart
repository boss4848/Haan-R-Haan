import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/main/main_page.dart';

import '../../../../constant/constant.dart';
import '../../bill_detail/billPage.dart';

class NavButton extends StatelessWidget {
  const NavButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 40,
      child: ElevatedButton(
        child: Text(
          ' Get started now ',
          style: TextStyle(fontSize: 17),
        ),
        style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            backgroundColor: kButtonColor,
            shadowColor: Color.fromARGB(255, 0, 0, 0),
            elevation: 15),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        },
      ),
    );
  }
}
