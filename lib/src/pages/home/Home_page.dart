import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/models/billDetail_models.dart';
import 'package:haan_r_haan/src/pages/details/bill_detail_owner.dart';
import 'package:haan_r_haan/src/pages/select_member/select_member_page.dart';
import 'package:haan_r_haan/src/services/notification_service.dart';
import 'package:haan_r_haan/src/widgets/show_more.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/party_model.dart';
import '../../viewmodels/party_view_model.dart';
import '../../viewmodels/user_view_model_draft.dart';
import '../bill_detail/member_bill_detail/bill_member_page.dart';
import '../bill_detail/owner_bill_detail/bill_owner_page.dart';

import '../../../constant/constant.dart';
import '../notification/notification_page.dart';
import './widget/custom_appbar.dart';
import '../../widgets/title.dart';
import '../../widgets/shadow_container.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // Provider.of<UserViewModel>(context, listen: false).fetchUserData();
    super.initState();
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formatted = DateFormat('EEE dd MMM HH:mm').format(dateTime);
    return formatted;
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('EEE dd MMM HH:mm').format(dateTime);
  }

  String formatTimeAgo(Timestamp timestamp) {
    final timestampInt = timestamp.millisecondsSinceEpoch;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInt);
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    return timeago.format(now.subtract(difference));
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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where('email',
                    isEqualTo: FirebaseAuth.instance.currentUser!.email)
                .snapshots()
                .asyncMap(
                  (userSnapshot) => FirebaseFirestore.instance
                      .collection("parties")
                      .where('ownerID', isEqualTo: userSnapshot.docs[0].id)
                      .snapshots()
                      .first,
                ),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No parties.'));
                } else {
                  final parties = snapshot.data!.docs.toList();
                  return Column(
                    children: [
                      TitleBar(
                        title: "Party List",
                        subTitle: "as owner - ${parties.length} parties",
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                          bottom: 10,
                        ),
                        decoration: boxShadow_1,
                        child: Column(
                          children: List.generate(
                            parties.length,
                            (index) => _buildPartyItem(
                              party: parties[index],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return const Center(child: Text('No data.'));
              }
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where('email',
                    isEqualTo: FirebaseAuth.instance.currentUser!.email)
                .snapshots()
                .asyncMap(
                  (userSnapshot) => FirebaseFirestore.instance
                      .collection("parties")
                      .where('members', arrayContains: userSnapshot.docs[0].id)
                      .where('isDraft', isEqualTo: false)
                      .where('ownerID', isNotEqualTo: userSnapshot.docs[0].id)
                      // .where('ownerID', isNotEqualTo: (userSnapshot.docs[0].id))
                      .snapshots()
                      .first,
                ),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No parties.'));
                } else {
                  final parties = snapshot.data!.docs.toList();
                  return Column(
                    children: [
                      TitleBar(
                        title: "Party List",
                        subTitle: "as member - ${parties.length} parties",
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                          bottom: 10,
                        ),
                        decoration: boxShadow_1,
                        child: Column(
                          children: List.generate(
                            parties.length,
                            (index) {
                              return _buildPartyItem(
                                party: parties[index],
                                ownerName: parties[index]['ownerName'],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return const Center(child: Text('No data.'));
              }
            },
          ),

          // const TitleBar(
          //   title: "Party List",
          //   subTitle: "as owner - ${1} parties",
          // ),
          // const ShowMore(),
          // const TitleBar(
          //   title: "Party List",
          //   subTitle: "as member - ${1} parties",
          //   lastChild: "order by price",
          // ),
          // const ShowMore(),
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
                    child: Consumer<UserViewModel>(
                      builder: (context, viewModel, child) {
                        if (viewModel.currentUserData == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final username = viewModel.currentUserData!.username;
                        final greetingPhrases = [
                          "Grab a bite, $username?",
                          "Chow down, $username?",
                          "Join me, $username?",
                          "Share a table, $username?",
                          "Let's break bread, $username?",
                          "Dine with me, $username?",
                          "Food's better shared, $username.",
                          "Feast together, my treat, $username?",
                          "Good food and company, $username?",
                        ];
                        const textStyle = TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        );
                        return AnimatedTextKit(
                          animatedTexts: List.generate(
                            greetingPhrases.length,
                            (index) => TypewriterAnimatedText(
                              greetingPhrases[index],
                              textStyle: textStyle,
                              curve: Curves.bounceIn,
                              speed: const Duration(milliseconds: 200),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  print("clicked");
                  NotificationService().showNotification(
                    title: "Test",
                    body: "Test body",
                  );
                },
                icon: const Icon(
                  Icons.notifications,
                  size: 36,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildPartyItem({
    required QueryDocumentSnapshot<Object?> party,
    // required bool isDraft,
    String ownerName = "",
    // required String date,
    // required String subTitle,
    // required String detail,
    // required double price,
    // required Function navigator,
    // required String id,
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
                    "${party['partyName']}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    // "· 6 members",
                    "· ${formatTimeAgo(party['createdAt'])}",

                    // "· ${party['members'].length} members",
                    style: const TextStyle(
                      fontSize: 13,
                      color: kPrimaryColor,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 3),
              ownerName != ""
                  ? Text(
                      "by $ownerName",
                      style: const TextStyle(
                        fontSize: 13,
                        color: kPrimaryColor,
                      ),
                    )
                  : Text(
                      "${party['members'].length} members",
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
                  party['isDraft']
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: greenPastelColor,
                          ),
                          child: const Text(
                            "Draft",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: redPastelColor,
                          ),
                          child: Text(
                            "${party['totalAmount']} baht",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                  const SizedBox(height: 3),
                  if (!party['isDraft'])
                    const Text(
                      "Total amount",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => {
                  if (party['isDraft'])
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectMemberPage(
                            partyID: party.id,
                          ),
                        ),
                      )
                    }
                  else
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BillDetailOwnerPage(partyID: party.id),
                        ),
                      )
                    }
                },
                child: const Icon(
                  CupertinoIcons.chevron_forward,
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
