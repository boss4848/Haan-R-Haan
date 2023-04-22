import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/bill_detail/components/MemberAndBill.dart';
import 'package:haan_r_haan/src/pages/bill_detail/components/partyName.dart';

import '../../../../constant/constant.dart';
import '../../../models/billDetail_models.dart';
import 'foodList.dart';

class Bbody extends StatefulWidget {
  const Bbody({super.key});

  @override
  State<Bbody> createState() => _BbodyState();
}

class _BbodyState extends State<Bbody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: kDefaultBG),
      child: Column(
        children: [
          PartyBar(party: parties[0]),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FoodList(
                party: parties[0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
