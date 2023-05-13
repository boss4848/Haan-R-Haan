import 'package:flutter/material.dart';
import '../../../../constant/constant.dart';
import '../../../models/user_model.dart';

class UserItem extends StatelessWidget {
  final UserModel user;
  final Function handleFunction;
  final Color buttonColor;
  final String buttonName;
  const UserItem({
    super.key,
    required this.user,
    required this.handleFunction,
    this.buttonColor = kPrimaryColor,
    required this.buttonName,
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
                user.username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                user.email,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildButton(
            buttonName: buttonName,
            backgroundColor: buttonColor,
            onPressed: () => handleFunction(),
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
