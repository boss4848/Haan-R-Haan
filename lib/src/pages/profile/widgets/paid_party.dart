import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/bill_detail/member_bill_detail/bill_member_page.dart';

import '../../../../constant/constant.dart';
import '../../../widgets/shadow_container.dart';
import '../../../widgets/show_more.dart';
import '../../../widgets/title.dart';
import '../../bill_detail/owner_bill_detail/bill_owner_page.dart';

class PaidPartyList extends StatelessWidget {
  final String name;
  final String people;
  final String date;
  final String money;

  const PaidPartyList(
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MemberBillDetail()));
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
                      const SizedBox(
                        height: 5,
                      ),
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

class PaidPartyWidget extends StatefulWidget {
  const PaidPartyWidget({super.key});

  @override
  State<PaidPartyWidget> createState() => _PaidPartyWidgetState();
}

class _PaidPartyWidgetState extends State<PaidPartyWidget> {
  bool isBillpaid = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const TitleBar(
          title: "Your History",
          subTitle: "${10} parties",
        ),
        ShadowContainer(
          element: _buildHistoryPartyItem(
            partyName: "Party name",
            date: "Tue 18 Apr 22:26",
            subTitle: "6",
            detail: "Total 600 baht",
            status: isBillpaid,
            navigator: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MemberBillDetail(),
                  ));
            },
          ),
          length: 3,
        ),
        const ShowMore(),
      ],
    );
  }

  Padding _buildHistoryPartyItem({
    required String partyName,
    required String date,
    required String subTitle,
    required String detail,
    required bool status,
    required Function navigator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    partyName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    '·',
                    style: TextStyle(
                      fontSize: 13,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    CupertinoIcons.person_2_fill,
                    size: 16,
                    color: kPrimaryColor,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    // "· 6 members",
                    subTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                date,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: status ? greenPastelColor : redPastelColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          status ? "Paid" : "Unpaid",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        Icon(
                          status ? Icons.check_rounded : Icons.close_rounded,
                          color: kSecondaryColor,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detail,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => navigator(),
                child: const Icon(
                  CupertinoIcons.back,
                  textDirection: TextDirection.rtl,
                  color: kPrimaryColor,
                  size: 20,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
