//only for bill detail.I'll make just One Party for make all component
class Party {
  final int id;
  final double totalPrice;
  final List<double> foodPrice;
  final List<String> foodName, member;
  final String partyName, QRcode;
  final List<Map> allMember;

  Party(
      {required this.id,
      required this.partyName,
      required this.foodName,
      required this.foodPrice,
      required this.totalPrice,
      required this.member,
      required this.QRcode,
      required this.allMember});
}

List<Party> parties = [
  Party(
      id: 1,
      partyName: "CS Gang",
      foodName: ["เหล้าหอมๆ", "เบียร์หวานๆ"],
      foodPrice: [190, 100],
      totalPrice: 290,
      member: ["Boss", "Yo", "Dol"],
      QRcode: "assets/images/qrtest.png",
      allMember: [
        {"name": "Boss", "bill": 113.3},
        {"name": "Yo", "bill": 113.3},
        {"name": "Dol", "bill": 53.3},
      ])
];
