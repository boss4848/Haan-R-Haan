import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/models/friend_request_model.dart';

import '../../../../constant/constant.dart';
import '../../../models/user_model.dart';
import '../../../utils/format.dart';

class FriendRequestItem extends StatelessWidget {
  final UserModel senderUserModel;
  final FriendRequestModel friendRequestModel;
  final Function onAcceptFriendRequest;
  final Function onDeclineFriendRequest;
  const FriendRequestItem({
    super.key,
    required this.friendRequestModel,
    required this.onAcceptFriendRequest,
    required this.onDeclineFriendRequest,
    required this.senderUserModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                senderUserModel.username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                formatTimestamp(friendRequestModel.timestamp),
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
              onPressed: () => onAcceptFriendRequest()),
          const SizedBox(width: 8),
          _buildButton(
            buttonName: "Decline",
            backgroundColor: redPastelColor,
            onPressed: () => onDeclineFriendRequest(),
          ),
        ],
      ),
    );
  }

  TextButton _buildButton({
    required String buttonName,
    required Color backgroundColor,
    required Function()? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
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
      child: Text(
        buttonName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }
}
