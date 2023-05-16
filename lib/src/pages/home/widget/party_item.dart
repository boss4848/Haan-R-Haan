import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/select_member/select_member_page.dart';

import '../../../../constant/constant.dart';
import '../../../models/party_model.dart';
import '../../../utils/format.dart';
import '../../detail/bill_detail_page.dart';

class PartyItem extends StatelessWidget {
  final PartyModel party;
  final bool isOwner;
  const PartyItem({
    super.key,
    required this.party,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (party.isDraft) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectMemberPage(
                party: party,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BillDetailPage(party: party),
            ),
          );
        }
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        party.partyName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        // "· 6 members",
                        "· ${formatTimeAgo(party.createdAt)}",

                        // "· ${party['members'].length} members",
                        style: const TextStyle(
                          fontSize: 13,
                          color: kPrimaryColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 3),
                  !isOwner
                      ? Text(
                          "by ${party.ownerName}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: kPrimaryColor,
                          ),
                        )
                      : Text(
                          "${party.members.length} members",
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
                      party.isDraft
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: greenPastelColor,
                              ),
                              child: const Text(
                                "Draft",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: redPastelColor,
                              ),
                              child: Text(
                                "${party.totalAmount} baht",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                      const SizedBox(height: 3),
                      if (!party.isDraft)
                        const Text(
                          "Total amount",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    CupertinoIcons.chevron_forward,
                    color: kPrimaryColor,
                    size: 20,
                  ),
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
