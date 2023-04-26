import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/bill_detail/components/arrowBack.dart';

class NotiFriend extends StatelessWidget {
  final String name;
  final String time;

  const NotiFriend({super.key, required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$name added your friend",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                time,
                style: const TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
