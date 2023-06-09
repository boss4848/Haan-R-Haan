//only for bill detail.I've make it just One Party for make all component
import 'package:flutter/material.dart';

class Party {
  final int id;
  final double totalPrice;
  final List<double> foodPrice;
  final List<String> foodName, member;
  final String partyName, owner, ownerPhone;
  final List<Map> allMember;
  final DateTime dateAndTime;

  Party(
      {required this.id,
      required this.dateAndTime,
      required this.partyName,
      required this.owner,
      required this.ownerPhone,
      required this.foodName,
      required this.foodPrice,
      // required this.totalPrice,
      required this.member,
      required this.allMember})
      : totalPrice = foodPrice.reduce((value, element) => value + element);
}

List<Party> parties = [
  Party(
    id: 1,
    dateAndTime: DateTime.now(),
// dateAndTime: DateTime(2023, 4, 22, 13, 30),
    partyName: "CS Gang",
    owner: "Boss",
    ownerPhone: '0643132586',
    foodName: [
      "เหล้าหอมๆ",
      "เบียร์หวานๆ",
      "เฟรนช์ฟรายส์อุ่นๆ",
      "ถั่วมันๆ",
      "แมวต้มร้อนๆ"
    ],
    foodPrice: [190, 100, 120, 30, 799],
    // totalPrice: 290,
    member: ["Boss", "Yo", "Dol"],
    allMember: [
      {"name": "Boss", "bill": 113.3},
      {"name": "Yo", "bill": 113.3},
      {"name": "Dol", "bill": 53.3},
      {"name": "Fahsai", "bill": 113.3},
      {"name": "Gift", "bill": 113.3},
      {"name": "Oil", "bill": 53.3},
      {"name": "Mark", "bill": 113.3},
      {"name": "Yo's friend", "bill": 113.3},
      {"name": "Mark's FWB", "bill": 53.3},
      {"name": "Fam", "bill": 113.3},
      {"name": "Tos", "bill": 113.3},
      {"name": "Boss2", "bill": 53.3},
    ],
  ),
  Party(
      id: 2,
      dateAndTime: DateTime.now(),
      partyName: "จ่ายด้วยน้อง",
      owner: "Yo",
      ownerPhone: '0956786848',
      foodName: [
        "VodKa Bucket",
        "มะนาวดอง",
        "vat",
      ],
      foodPrice: [
        1700,
        50,
        123
      ],
      member: [
        "Boss",
        "Yo",
        "Dol"
      ],
      allMember: [
        {"name": "Boss", "bill": 113.3},
        {"name": "Yo", "bill": 113.3},
        {"name": "Dol", "bill": 53.3},
      ])
];
