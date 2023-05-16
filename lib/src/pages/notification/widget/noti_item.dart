import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/utils/format.dart';

class NotiItem extends StatelessWidget {
  final String title;
  final String body;
  final Timestamp dateCreated;

  const NotiItem({
    super.key,
    required this.title,
    required this.body,
    required this.dateCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: boxShadow_1,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                formatTimeAgo(dateCreated),
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 13,
                  // fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
