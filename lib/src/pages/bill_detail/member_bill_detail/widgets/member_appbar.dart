import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

import 'package:haan_r_haan/src/pages/bill_detail/owner_bill_detail/widgets/BillcustomBar.dart';
import 'package:intl/intl.dart';

import '../../../../models/billDetail_models.dart';
import '../../owner_bill_detail/widgets/arrowBack.dart';

import 'member_custombar.dart';

class memberPartyBar extends StatelessWidget {
  final Party party;

  const memberPartyBar({
    super.key,
    required this.party,
  });
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE MMMM d, y');
    final timeFormat = DateFormat('HH:mm');

    //final timeFormat = DateFormat('h:mm a');

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 85),
              height: 170,
              decoration: const BoxDecoration(gradient: kDefaultBG),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: kDefaultPadding / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const arrowBack(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                party.partyName,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text('by ${party.owner}',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall),
                                  const SizedBox(
                                    width: kDefaultPadding / 4,
                                  ),
                                  Text(
                                      '${dateFormat.format(party.dateAndTime)} ${timeFormat.format(party.dateAndTime)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: kSecondaryColor)),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const MemberbillDetailBar(),
            Positioned(
              top: kDefaultPadding * 2.5,
              right: kDefaultPadding,
              child: IconButton(
                onPressed: () {
                  // Add your bin icon's action here
                },
                icon: Icon(Icons.delete),
                color: kSecondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
