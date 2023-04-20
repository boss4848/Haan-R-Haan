import 'package:flutter/material.dart';

import '../../bill_detail/bill_page.dart';

class PartyWidget extends StatelessWidget {
  final String name;
  final String people;
  final String date;
  final String money;

  const PartyWidget(
      {super.key,
      required this.name,
      required this.people,
      required this.date,
      required this.money});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 65,
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const BillDetailPage()));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(
                            Icons.circle,
                            size: 5,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text("$people peoples",
                              style: const TextStyle(
                                color: Colors.black,
                              ))
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Text(date,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          )),
                    ],
                  ),
                  Text("$money Baht",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
            )));
  }
}
