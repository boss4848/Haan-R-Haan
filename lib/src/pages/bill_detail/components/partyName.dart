import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:intl/intl.dart';

import '../../../models/billDetail_models.dart';
import 'arrowBack.dart';

class PartyBar extends StatelessWidget {
  final Party party;

  const PartyBar({
    super.key,
    required this.party,
  });
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMMM d, y');
    final timeFormat = DateFormat('HH:mm');

    //final timeFormat = DateFormat('h:mm a');

    return SafeArea(
      child: Row(
        children: [
          const arrowBack(),
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      party.partyName,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('by ${party.owner}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300)),
                  ],
                ),
                Row(
                  children: [
                    Text(
                        'Created on ${dateFormat.format(party.dateAndTime)} at ${timeFormat.format(party.dateAndTime)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'SFTHONBURI',
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
