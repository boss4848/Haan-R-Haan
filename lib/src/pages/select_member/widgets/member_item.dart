import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';
import '../../../models/user_model_draft.dart';

class MemberItem extends StatefulWidget {
  final UserModel friend;
  final ValueChanged<UserModel> onToggleSelected;
  final ValueNotifier<List<UserModel>> selectedFriends;
  final VoidCallback onUpdateSelectAll;

  const MemberItem({
    super.key,
    required this.friend,
    required this.onToggleSelected,
    required this.selectedFriends,
    required this.onUpdateSelectAll,
  });

  @override
  State<MemberItem> createState() => _MemberItemState();
}

class _MemberItemState extends State<MemberItem> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<UserModel>>(
      valueListenable: widget.selectedFriends,
      builder: (context, value, child) {
        bool isSelected = value.contains(widget.friend);
        return InkWell(
          onTap: () {
            isSelected = !isSelected;
            widget.onToggleSelected(widget.friend);
            widget.onUpdateSelectAll();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? greenPastelColor : redPastelColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? CupertinoIcons.minus : CupertinoIcons.add,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.friend.username,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
