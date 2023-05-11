import 'package:flutter/material.dart';

import '../../../../constant/constant.dart';

class CustomAppBar extends StatelessWidget {
  final TextEditingController controller;
  final Function onSubmitted;
  const CustomAppBar({
    super.key,
    required this.controller,
    // required this.onChanged,
    required this.onSubmitted,
  });
  final double appBarSize = 65;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: appBarSize,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: appBarSize,
            width: appBarSize,
            decoration: boxShadow_1,
            child: const Center(
              child: Icon(Icons.search, size: 30),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: boxShadow_1,
              child: Center(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Search...",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  controller: controller,
                  onSubmitted: (value) => onSubmitted(value),
                  // onChanged: (value) => onChanged(value),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
