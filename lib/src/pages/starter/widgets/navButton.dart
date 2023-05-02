import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/main/main_page.dart';

import '../../../../constant/constant.dart';
import '../../bill_detail/owner_bill_detail/bill_owner_page.dart';

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
          style: Theme.of(context).textTheme.headlineSmall,
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


// ElevatedButton(
//                 onPressed: () {},
//                 child: Text(
//                   'Elevated button',
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 style: Theme.of(context).elevatedButtonTheme.style!,
//               ),

// OutlinedButton(
//                 onPressed: () {},
//                 child: Text(
//                   'Outlined Button',
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 style: Theme.of(context).outlinedButtonTheme.style!,
//               ),


// TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   'Text Button',
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 style: Theme.of(context).textButtonTheme.style!,
//               )
