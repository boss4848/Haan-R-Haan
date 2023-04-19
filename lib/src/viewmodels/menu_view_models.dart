import 'package:flutter/material.dart';
import '../models/menu_models.dart';

class MenuViewModel {
  List<MenuModel> getMenus() {
    return [
      MenuModel(
        icon: Icons.home_outlined,
        iconSelected: Icons.home,
        label: "Home",
      ),
      MenuModel(
        icon: Icons.people_outline,
        iconSelected: Icons.people,
        label: "Friends",
      ),
      MenuModel(
        icon: Icons.add,
        iconSelected: Icons.add,
        label: "",
      ),
      MenuModel(
        icon: Icons.qr_code_outlined,
        iconSelected: Icons.qr_code,
        label: "Scan",
      ),
      MenuModel(
        icon: Icons.person_outlined,
        iconSelected: Icons.person,
        label: "Profile",
      ),
    ];
  }
}
