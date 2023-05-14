import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/widgets/shadow_container.dart';
import '../../../constant/constant.dart';
import '../../models/party_model.dart';
import '../../models/user_model.dart';
import '../../viewmodels/party_view_model.dart';
import '../../viewmodels/user_view_model.dart';
import './widget/custom_appbar.dart';
import '../../widgets/title.dart';
import 'widget/party_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final partyViewModel = PartyViewModel();
  final userViewModel = UserViewModel();

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
          StreamBuilder(
            stream: partyViewModel.fetchPartiesAsOwner(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<PartyModel> parties = snapshot.data!;
              return Column(
                children: [
                  TitleBar(
                    title: "Party List",
                    subTitle: "as owner",
                    lastChild: "${parties.length} parties",
                  ),
                  ShadowContainer(
                    partiesCount: parties.length,
                    list: List.generate(
                      parties.length,
                      (index) => PartyItem(
                        party: parties[index],
                        isOwner: true,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          StreamBuilder(
            stream: partyViewModel.fetchPartiesAsMember(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              print(snapshot.data);
              final List<PartyModel> parties = snapshot.data!;

              return Column(
                children: [
                  TitleBar(
                    title: "Party List",
                    subTitle: "as member",
                    lastChild: "${parties.length} parties",
                  ),
                  ShadowContainer(
                    partiesCount: parties.length,
                    list: List.generate(
                      parties.length,
                      (index) => PartyItem(
                        party: parties[index],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
                    child: FutureBuilder(
                      future: userViewModel.fetchUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        UserModel user = snapshot.data as UserModel;
                        final greetingPhrases = [
                          "Grab a bite, ${user.username}?",
                          "Chow down, ${user.username}?",
                          "Join me, ${user.username}?",
                          "Share a table, ${user.username}?",
                          "Let's break bread, ${user.username}?",
                          "Dine with me, ${user.username}?",
                          "Food's better shared, ${user.username}.",
                          "Feast together, my treat, ${user.username}?",
                          "Good food and company, ${user.username}?",
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
}
