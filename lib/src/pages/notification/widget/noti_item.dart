import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/utils/format.dart';

class NotiItem extends StatefulWidget {
  final String title;
  final String body;
  final Timestamp dateCreated;
  final String notiId;

  const NotiItem({
    super.key,
    required this.title,
    required this.body,
    required this.dateCreated,
    required this.notiId,
  });

  @override
  State<NotiItem> createState() => _NotiItemState();
}

class _NotiItemState extends State<NotiItem> {
  bool isDelete = false;
  @override
  Widget build(BuildContext context) {
    return !isDelete
        ? Container(
            width: double.infinity,
            decoration: boxShadow_1,
            margin: const EdgeInsets.only(bottom: 10),
            padding:
                const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('notifications')
                            .doc(widget.notiId)
                            .delete();
                        setState(() {
                          isDelete = true;
                        });
                      },
                      child: const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: greenPastelColor,
                        size: 20,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  widget.body,
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatTimeAgo(widget.dateCreated),
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 13,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
