import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/bill_detail/components/arrowBack.dart';
import 'package:haan_r_haan/src/pages/friends/friends_page.dart';
import 'package:haan_r_haan/src/pages/friends/components/searchBox.dart';

class AddFriendPage extends StatelessWidget {
  const AddFriendPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: kDefaultBG,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 55, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Add Friend",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50,
              left: 15,
              child: arrowBack()
            ),
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: SearchBox(
                onChanged: (value) {
                  // Handle search text changes here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
