import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:haan_r_haan/constant/constant.dart';

class ButtonOutlined extends StatelessWidget {
  final Function onPressed;
  final String buttonName;
  final IconData? icon;
  const ButtonOutlined({
    super.key,
    required this.onPressed,
    required this.buttonName,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        side: const BorderSide(color: kPrimaryColor),
        shadowColor: Colors.transparent,
      ),
      onPressed: () => onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: kPrimaryColor,
            ),
          if (icon != null) const SizedBox(width: 4),
          Text(
            buttonName,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
