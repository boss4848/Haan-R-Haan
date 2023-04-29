import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

import '../../models/menu_models.dart';
import '../../viewmodels/menu_view_models.dart';
import '../create_party/create_party_page.dart';
import '../friends/friends_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../scan/scan_page.dart';

Map userData = {};

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainPage> {
  getUserData() async {
    await FirebaseFirestore.instance.collection("users").get().then((value) {
      value.docs.forEach((element) {
        if (element.data()["email"] ==
            FirebaseAuth.instance.currentUser!.email) {
          setState(() {
            userData = element.data();
          });
          print(element.data());
        }
      });
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  final List<MenuModel> _menuViewModel = MenuViewModel().getMenus();
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
      body: Container(
        decoration: const BoxDecoration(
          // gradient: kDefaultBG,
          color: blueBackgroundColor,
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            HomePage(),
            FriendsPage(),
            CreatePartyPage(),
            ScanPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        menuViewModel: _menuViewModel,
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final List<MenuModel> menuViewModel;
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.menuViewModel,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double height = 65;

    return BottomAppBar(
      color: Colors.white,
      elevation: 0,
      child: Stack(
        children: [
          Container(
            height: height,
          ),
          Center(
            heightFactor: 0.6,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: menuViewModel
                  .asMap()
                  .map((int index, MenuModel menuModel) {
                    final isSelect = index == selectedIndex;
                    final color = isSelect ? kPrimaryColor : Colors.black54;
                    String text = menuModel.label;
                    if (index == 2) {
                      return MapEntry(
                          index,
                          const SizedBox(
                            width: 60,
                          ));
                    }
                    return MapEntry(
                      index,
                      GestureDetector(
                        onTap: () => onTap(index),
                        child: Tab(
                          iconMargin: const EdgeInsets.all(0),
                          icon: const SizedBox(),
                          child: Column(
                            children: [
                              _buildIcon(
                                icon: isSelect
                                    ? menuModel.iconSelected
                                    : menuModel.icon,
                                color: color,
                                index: index,
                              ),
                              _buildLabel(
                                text: text,
                                color: color,
                                wrapText: menuViewModel[0].label == text,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                  .values
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  _buildIcon({
    required IconData icon,
    required Color color,
    required int index,
  }) {
    return Icon(
      icon,
      color: color,
      size: 32,
    );
  }

  _buildLabel({
    required String text,
    required Color color,
    required bool wrapText,
  }) {
    return Baseline(
      baselineType: TextBaseline.alphabetic,
      baseline: 12,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          letterSpacing: wrapText ? -1.0 : null,
        ),
      ),
    );
  }
}
