import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';

class NotiOverdued extends StatelessWidget {
  final String partyName;
  final String time;
  final String money;

  const NotiOverdued({super.key, required this.partyName, required this.money, required this.time});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {

        },
        style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Amount overdue",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                  const SizedBox(height: 5,),
                  Text("$money Baht - $partyName",style: const TextStyle(color: Colors.black),),
                ],
              ),
              Text(time, style: const TextStyle(color: Colors.black),)
            ],
          ),
          ),
      ),
    );
  }
}