import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';

class NotiBillPaid extends StatelessWidget {
  final String partyName;
  final String time;
  final String name;
  final String money;

  const NotiBillPaid({super.key, required this.partyName, required this.money, required this.time, required this.name});

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
                  const Text("Your bill has been paid",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                  const SizedBox(height: 5,),
                  Text("$name has checked your $money baht bill",style: const TextStyle(color: Colors.black),),
                  Text("- $partyName",style: const TextStyle(color: Colors.black))
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