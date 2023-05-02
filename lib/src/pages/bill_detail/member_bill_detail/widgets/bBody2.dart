import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/bill_detail/member_bill_detail/widgets/foodlist_m.dart';
import 'package:haan_r_haan/src/pages/bill_detail/member_bill_detail/widgets/member_appbar.dart';

import '../../../../../constant/constant.dart';
import '../../../../models/billDetail_models.dart';
import '../../owner_bill_detail/widgets/foodList.dart';
import '../../owner_bill_detail/widgets/partyName.dart';
import 'member_custombar.dart';

class Bmemberbody extends StatefulWidget {
  const Bmemberbody({super.key});

  @override
  State<Bmemberbody> createState() => _BmemberbodyState();
}

class _BmemberbodyState extends State<Bmemberbody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          memberPartyBar(party: parties[1]),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: foodlistForMember(
                party: parties[1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
