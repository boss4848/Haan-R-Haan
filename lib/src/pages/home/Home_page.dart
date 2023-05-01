import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/main/main_page.dart';
import 'package:haan_r_haan/src/widgets/show_more.dart';
import '../bill_detail/owner_bill_detail/bill_owner_page.dart';

import '../../../constant/constant.dart';
import './widget/custom_appbar.dart';
import '../../widgets/title.dart';
import '../../widgets/shadow_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String addNewLineAfterSixWords(String phrase) {
    final List<String> words = phrase.split(' ');
    final int numWords = words.length;

    if (numWords <= 6) {
      return phrase; // return the original phrase if it has 6 or fewer words
    }

    String newPhrase = ''; // initialize the new phrase string

    for (int i = 0; i < numWords; i += 6) {
      final int end = (i + 6 < numWords) ? i + 6 : numWords;
      final String line =
          words.sublist(i, end).join(' '); // get 6 words at a time
      newPhrase +=
          '$line\n'; // add the line to the new phrase with a newline character
    }

    return newPhrase.trim(); // remove any trailing whitespace
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _buildBanner(),
              const CustomAppBar(),
            ],
          ),
          const SizedBox(height: 10),
          const TitleBar(
            title: "Party List",
            subTitle: "as owner - ${1} parties",
          ),
          ShadowContainer(
            element: _buildPartyItem(
              partyName: "Party name",
              date: "Tue 18 Apr 22:26",
              subTitle: "· 6 members",
              detail: "Total amount 600 baht",
              price: -500,
              navigator: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OwnerBillDetailPage(),
                    ));
              },
            ),
            length: 3,
          ),
          const ShowMore(),
          const TitleBar(
            title: "Party List",
            subTitle: "as member - ${1} parties",
            lastChild: "order by price",
          ),
          ShadowContainer(
            element: _buildPartyItem(
              partyName: "Party name",
              date: "Tue 18 Apr 22:26",
              subTitle: "· username (owner)",
              detail: "Debt",
              price: 1300,
              navigator: () {},
            ),
            length: 3,
          ),
          const ShowMore(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Container _buildBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      height: 210,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: kDefaultBG,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
            top: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/nameBanner4.png", height: 60),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      greetingPhrases[Random().nextInt(greetingPhrases.length)],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.notifications,
                size: 36,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildPartyItem({
    required String partyName,
    required String date,
    required String subTitle,
    required String detail,
    required int price,
    required Function navigator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    partyName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    // "· 6 members",
                    subTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 3),
              Text(
                date,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: redPastelColor,
                    ),
                    child: Text(
                      "$price baht",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detail,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => navigator(),
                child: const Icon(
                  CupertinoIcons.back,
                  textDirection: TextDirection.rtl,
                  color: kPrimaryColor,
                  size: 20,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
