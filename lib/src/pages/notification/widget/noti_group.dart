import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';

class NotiGroup extends StatelessWidget {
  final String name;
  final String partyName;
  final String time;

  const NotiGroup({super.key, required this.name, required this.time, required this.partyName});

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
                  Flexible(child: Text("$name joined your party",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                  const SizedBox(height: 4,),
                  Flexible(child: Text(partyName, style: const TextStyle(color: Colors.black),))
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