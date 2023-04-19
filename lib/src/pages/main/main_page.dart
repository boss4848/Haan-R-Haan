import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

import '../../models/menu_models.dart';
import '../../viewmodels/menu_view_models.dart';
import '../create_party/create_party_page.dart';
import '../friends/friends_page.dart';
import '../home/Home_page.dart';
import '../profile/profile_page.dart';
import '../scan/scan_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainPage> {
  final List<MenuModel> _menuViewModel = MenuViewModel().getMenus();
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _menuViewModel.length,
      child: Scaffold(
        // backgroundColor: Colors.amber,
        body: Container(
          decoration: const BoxDecoration(
            gradient: kDefaultBG,
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
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 1.5,
                spreadRadius: 0.5,
              )
            ],
            color: Colors.white,
          ),
          child: SafeArea(
              child: CustomTabBar(
            menuViewModel: _menuViewModel,
            selectedIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          )),
        ),
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final List<MenuModel> menuViewModel;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomTabBar({
    super.key,
    required this.menuViewModel,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: Colors.transparent,
      indicatorPadding: EdgeInsets.zero,
      labelPadding: EdgeInsets.zero,
      tabs: menuViewModel
          .asMap()
          .map(
            (int index, MenuModel menuModel) {
              final isSelect = index == selectedIndex;
              final color = isSelect ? kButtonColor : Colors.black54;
              String text = menuModel.label;

              return MapEntry(
                index,
                Tab(
                  iconMargin: const EdgeInsets.all(0),
                  icon: const SizedBox(),
                  child: Column(
                    children: [
                      _buildIcon(
                        icon:
                            isSelect ? menuModel.iconSelected : menuModel.icon,
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
              );
            },
          )
          .values
          .toList(),
      onTap: onTap,
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
      size: 30,
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
          fontSize: 9,
          color: color,
          letterSpacing: wrapText ? -1.0 : null,
        ),
      ),
    );
  }
}
