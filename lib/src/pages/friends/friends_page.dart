import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/widgets/shadow_container.dart';
import 'package:haan_r_haan/src/widgets/show_more.dart';
import 'package:haan_r_haan/src/widgets/title.dart';

import 'widgets/custom_appbar.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _scrollController = TrackingScrollController();
  final searchController = TextEditingController();

  //Handle scroll
  late Color _backgroundColor;
  late double _opacity;
  late double _offset;
  @override
  void initState() {
    _backgroundColor = Colors.transparent;
    _opacity = 0.0;
    _offset = 0.0;

    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    height: 170,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: kDefaultBG,
                    ),
                  ),
                  CustomAppBar(controller: searchController),
                ],
              ),
              const SizedBox(height: 10),
              const TitleBar(
                title: "Friend Request",
                subTitle: "3 request",
                isNoSpacer: true,
              ),
              ShadowContainer(
                length: 3,
                element: _buildFriendRequestItem(
                  username: "Passakorn",
                  date: "Tue 19 Apr 22:26",
                ),
              ),
              const TitleBar(
                title: "Friend List",
                subTitle: " 2 friends",
                isNoSpacer: true,
              ),
              ShadowContainer(
                length: 2,
                element: _buildFriendItem(
                  username: "Passakorn",
                  email: "passakorn_2@gmail.com",
                ),
              ),
              const ShowMore(),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Container(
          color: _backgroundColor,
          // height: 160,
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
                children: const [
                  Text(
                    "Friends",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: kSecondaryColor),
                  ),
                  Icon(
                    Icons.notifications,
                    size: 36,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildFriendRequestItem({
    String? username,
    String? date,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username ?? "Username",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                date ?? "Tue 19 Apr 22:26",
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildButton(
            buttonName: "Accept",
            backgroundColor: kPrimaryColor,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _buildButton(
            buttonName: "Decline",
            backgroundColor: redPastelColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Padding _buildFriendItem({
    String? username,
    String? email,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username ?? "Username",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                email ?? "user_email@mail.com",
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildButton(
            buttonName: "Remove",
            backgroundColor: redPastelColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  TextButton _buildButton({
    required String buttonName,
    required Color backgroundColor,
    required Function onPressed,
  }) {
    return TextButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size(80, 32),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size(80, 32),
        ),
        backgroundColor: MaterialStateProperty.all(
          backgroundColor,
        ),
      ),
      onPressed: () => onPressed,
      child: Text(
        buttonName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }

  _onScroll() {
    final scrollOffset = _scrollController.offset;
    if (scrollOffset >= _offset && scrollOffset > 5) {
      _opacity = (_opacity + 0.02).clamp(0.0, 1.0);
      _offset = scrollOffset;
    } else if (scrollOffset < 100) {
      _opacity = (_opacity - 0.02).clamp(0.0, 1.0);
    }

    setState(() {
      if (scrollOffset <= 0) {
        _offset = 0.0;
        _opacity = 0.0;
      }
      _backgroundColor = kPrimaryColor.withOpacity(_opacity);
    });
  }
}
