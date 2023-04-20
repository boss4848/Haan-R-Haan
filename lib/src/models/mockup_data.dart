//only for bill detail.I've make it just One Party for make all component
class Party {
  final int id;
  final double totalPrice;
  final List<double> foodPrice;
  final List<String> foodName, member;
  final String partyName, owner, ownerPhone;
  final List<Map> allMember;

  Party(
      {required this.id,
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
      partyName: "CS Gang",
      owner: "Boss",
      ownerPhone: '0956786848',
      foodName: [
        "เหล้าหอมๆ",
        "เบียร์หวานๆ",
        "เฟรนช์ฟรายส์อุ่นๆ",
        "ถั่วมันๆ",
        "แมวต้มร้อนๆ"
      ],
      foodPrice: [
        190,
        100,
        120,
        30,
        799
      ],
      // totalPrice: 290,
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
