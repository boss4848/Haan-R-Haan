import 'package:flutter/cupertino.dart';

import '../models/menu_model.dart';

class MenuViewModel {
  List<MenuModel> getMenus() {
    return [
      MenuModel(
        icon: CupertinoIcons.house,
        iconSelected: CupertinoIcons.house_fill,
        label: "Home",
      ),
      MenuModel(
        icon: CupertinoIcons.person_2,
        iconSelected: CupertinoIcons.person_2_fill,
        label: "Friends",
      ),
      MenuModel(
        icon: CupertinoIcons.add,
        iconSelected: CupertinoIcons.add,
        label: "",
      ),
      MenuModel(
        icon: CupertinoIcons.qrcode_viewfinder,
        iconSelected: CupertinoIcons.qrcode_viewfinder,
        label: "Scan",
      ),
      MenuModel(
        icon: CupertinoIcons.person_crop_circle,
        iconSelected: CupertinoIcons.person_crop_circle_fill,
        label: "Profile",
      ),
    ];
  }
}
