import 'package:flutter/material.dart';

import '../../../models/mockup_data.dart';
import 'arrowBack.dart';

class PartyBar extends StatelessWidget {
  final Party party;
  const PartyBar({super.key, required this.party});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Row(
        children: [
          arrowBack(),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              party.partyName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontFamily: 'SFTHONBURI',
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
