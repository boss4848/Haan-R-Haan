import 'package:flutter/material.dart';

Future loading(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
