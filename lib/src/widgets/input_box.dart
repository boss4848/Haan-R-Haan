import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class InputBox extends StatelessWidget {
  final bool showLabel;
  final String label;
  final TextEditingController controller;
  final String errorText;
  final bool obscureText;
  final bool? isMini;
  final bool isShadow;
  final bool isLight;
  const InputBox({
    super.key,
    this.obscureText = false,
    this.label = "",
    this.showLabel = true,
    this.isMini = false,
    this.isShadow = true,
    this.isLight = false,
    required this.controller,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Text(
            label,
            style: isLight
                ? Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: greyBackgroundColor,
                      fontSize: 16,
                    )
                : Theme.of(context).textTheme.labelMedium,
          ),
        const SizedBox(height: 10),
        Container(
          decoration: isShadow ? null : boxShadow_1,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: isMini! ? 25 : 15,
                vertical: isMini! ? 20 : 10,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: isLight ? greyBackgroundColor : Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: isLight ? greyBackgroundColor : Colors.white,
                ),
              ),
              fillColor: isLight ? greyBackgroundColor : Colors.white,
              filled: true,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          errorText,
          style: const TextStyle(
            color: errorColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
