import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';

class NotiDebt extends StatelessWidget {
  final String partyNumber;
  final String time;
  final String money;

  const NotiDebt({super.key, required this.partyNumber, required this.money, required this.time});

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
                  const Text("Your debt today...",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                  const SizedBox(height: 5,),
                  Flexible(child: Text("$money Baht - From $partyNumber parties",style: const TextStyle(color: Colors.black),)),
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