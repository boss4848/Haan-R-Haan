import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class InputBox extends StatelessWidget {
  final bool showLabel;
  final String label;
  final TextEditingController controller;
  final String errorText;
  final bool obscureText;
  final bool? isMini;
  const InputBox({
    super.key,
    this.obscureText = false,
    this.label = "",
    this.showLabel = true,
    this.isMini = false,
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
            style: Theme.of(context).textTheme.labelMedium,
          ),
        const SizedBox(height: 10),
        Container(
          decoration: boxShadow_2,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: isMini! ? 25 : 15,
                vertical: isMini! ? 20 : 10,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              fillColor: Colors.white,
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
