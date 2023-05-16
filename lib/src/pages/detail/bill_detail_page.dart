import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/viewmodels/noti_view_model.dart';
import 'package:haan_r_haan/src/viewmodels/user_view_model.dart';
import 'package:haan_r_haan/src/widgets/loading_dialog.dart';
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';

import '../../../constant/constant.dart';
import '../../models/party_model.dart';
import '../../models/user_model.dart';
import '../../utils/format.dart';
import '../../widgets/title.dart';
import '../select_food/widgets/member.dart';

class BillDetailPage extends StatefulWidget {
  final PartyModel party;
  const BillDetailPage({
    required this.party,
    super.key,
  });

  @override
  State<BillDetailPage> createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  final _auth = FirebaseAuth.instance;

  onDeleteParty() async {
    loadingDialog(context);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    //delete userTotalDebt
    print('delete');
    final PartyModel party = await FirebaseFirestore.instance
        .collection('parties')
        .doc(widget.party.partyID)
        .get()
        .then(
      (value) {
        return PartyModel.fromFirestore(value);
      },
    );

    for (var member in party.paymentList) {
      if (member['isPaid'] == false) {
        await UserViewModel().fetchUserByID(member['id']).then(
          (value) async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(member['id'])
                .update(
              {
                'userTotalDebt': value.userTotalDebt - member['payment'],
              },
            );
          },
        );
      }
    }
    //delete userTotalLent (owner)

    //get totalLent from party

    await UserViewModel().fetchUserByID(widget.party.ownerID).then(
      (value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.party.ownerID)
            .update(
          {
            'userTotalLent': value.userTotalLent - party.totalLent,
          },
        );
      },
    );
    await FirebaseFirestore.instance
        .collection('parties')
        .doc(widget.party.partyID)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final bool isOwner = widget.party.ownerID == _auth.currentUser!.uid;
    return Scaffold(
      body: Stack(
        children: [
          _buildContent(
            context,
            widget.party,
            isOwner,
          ),
          _buildBanner(
            context,
            widget.party,
            isOwner,
          ),
        ],
      ),
    );
  }

  Stack _buildBanner(
    BuildContext context,
    PartyModel party,
    bool isOwner,
  ) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 85),
          decoration: const BoxDecoration(
            gradient: kDefaultBG,
          ),
          height: 170,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.party.partyName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.party.ownerName,
                            style: const TextStyle(
                              fontSize: 19,
                              color: kSecondaryColor,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            formatTimestamp(party.createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (isOwner)
                    GestureDetector(
                      onTap: onDeleteParty,
                      child: const Icon(
                        CupertinoIcons.trash_fill,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: boxShadow_1,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: greyBackgroundColor,
                  ),
                  child: Text(
                    widget.party.partyDesc,
                    style: const TextStyle(
                      fontSize: 19,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('parties')
                        .doc(widget.party.partyID)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      if (!snapshot.hasData) {
                        return const Text("Loading");
                      }

                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      int paidCount = data['paidCount'] ?? 0;
                      double totalLent = (data['totalLent'] ?? 0).toDouble();
                      double totalAmount =
                          (data['totalAmount'] ?? 0).toDouble();

                      return Row(
                        children: [
                          _buildStatus(
                            context: context,
                            sub: "unpaid",
                            value: data['members'].length - paidCount,
                            unit: "Members",
                          ),
                          Container(
                            width: 1.2,
                            height: 50,
                            color: greyBackgroundColor,
                          ),
                          _buildStatus(
                            context: context,
                            sub: "TOTAL AMOUNT",
                            value: totalAmount.toInt(),
                            unit: "฿",
                          ),
                          Container(
                            width: 1.2,
                            height: 50,
                            color: greyBackgroundColor,
                          ),
                          _buildStatus(
                            context: context,
                            sub: "TOTAL LENT",
                            value: totalLent.toInt(),
                            unit: "฿",
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Container _buildContent(
    BuildContext context,
    PartyModel party,
    bool isOwner,
  ) {
    final payments = widget.party.paymentList;
    double amount = 0.0;
    for (var i = 0; i < payments.length; i++) {
      if (payments[i]['id'] == _auth.currentUser!.uid) {
        amount = payments[i]['payment'].toDouble();
      }
    }

    return Container(
      color: blueBackgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 260),
              TitleBar(
                title: "Food List",
                subTitle: "${widget.party.foodList.length} foods",
                isNoPadding: true,
              ),
              Column(
                children: List.generate(widget.party.foodList.length, (index) {
                  return Container(
                    decoration: boxShadow_2,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.party.foodList[index]['foodName'],
                              // "test",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                            Text(
                              "${widget.party.foodList[index]['foodPrice']} Baht",
                              style: const TextStyle(
                                fontSize: 16,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: List.generate(
                            widget.party.foodList[index]['eaters'].length,
                            (i) {
                              return FutureBuilder(
                                future: UserViewModel().fetchUserByID(
                                  widget.party.foodList[index]['eaters'][i],
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Member(
                                      name: "Loading...",
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    return const Text("Loading");
                                  }
                                  return Member(
                                    name: snapshot.data!.username,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('parties')
                      .doc(widget.party.partyID)
                      .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const CircularProgressIndicator();
                    }

                    return TitleBar(
                      title: "Who has paid?",
                      subTitle:
                          "${snap.data?['paidCount']}/${widget.party.members.length} members",
                      isNoPadding: true,
                    );
                  }),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 20, left: 5),
                decoration: boxShadow_1,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('parties')
                      .doc(widget.party.partyID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      final parties = snapshot.data as DocumentSnapshot;
                      // final payments = parties.get('payments') as List;
                      return Column(
                        children: payments.map((payerPayment) {
                          return Row(
                            children: [
                              PaymentCheckbox(
                                isOwner: isOwner,
                                isPaid: payerPayment['isPaid'] ?? false,
                                payerId: payerPayment['id'],
                                partyId: widget.party.partyID,
                                ownerId: parties['ownerID'],
                                partyName: widget.party.partyName,
                              ),
                              FutureBuilder(
                                future: UserViewModel().fetchUserByID(
                                  payerPayment['id'],
                                ),
                                builder: (context, snapshot) {
                                  // if (snapshot.connectionState ==
                                  //     ConnectionState.waiting) {
                                  //   return const Text("Loading...");
                                  // }
                                  if (snapshot.data == null) {
                                    return const Text("Loading...");
                                  }
                                  return Text(
                                    snapshot.data!.username,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                              const Spacer(),
                              Text(
                                "${(payerPayment['payment']).toStringAsFixed(2)} Baht",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
              TitleBar(
                title: "Promptpay",
                subTitle: isOwner ? '(ไม่ระบุจำนวนเงิน)' : '(ระบุจำนวนเงิน)',
                isNoPadding: true,
              ),
              Container(
                decoration: boxShadow_1,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: QRCodeGenerate(
                  promptPayId: widget.party.promptpay,
                  isShowAmountDetail: false,
                  amount: isOwner ? 0.0 : amount,
                  promptPayDetailCustom: Column(
                    children: [
                      Text(
                        "Party name: ${widget.party.partyName}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(
                        "Promptpay: ${widget.party.promptpay}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                        ),
                      ),
                      if (!isOwner)
                        Text(
                          "You need to pay ${amount.toStringAsFixed(2)} baht",
                          style: const TextStyle(
                            fontSize: 16,
                            color: kPrimaryColor,
                          ),
                        ),
                      Text(
                        "Owner: ${widget.party.ownerName} ",
                        style: const TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildStatus({
    required BuildContext context,
    required String sub,
    required int value,
    required String unit,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$value",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(width: 5),
                Text(
                  unit,
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 13,
                  ),
                )
              ],
            ),
            const SizedBox(height: 3),
            Text(
              sub.toUpperCase(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentCheckbox extends StatefulWidget {
  final bool isOwner;
  final bool isPaid;
  final String payerId;
  final String partyId;
  final String ownerId;
  final String partyName;

  const PaymentCheckbox({
    super.key,
    required this.isOwner,
    required this.isPaid,
    required this.payerId,
    required this.partyId,
    required this.ownerId,
    required this.partyName,
  });
  @override
  State<PaymentCheckbox> createState() => _PaymentCheckboxState();
}

class _PaymentCheckboxState extends State<PaymentCheckbox> {
  bool isPaid = false;

  @override
  void initState() {
    super.initState();
    isPaid = widget.isPaid;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isPaid,
      onChanged: (value) {
        if (widget.isOwner) {
          setState(
            () {
              isPaid = !isPaid;
              final partyRef = FirebaseFirestore.instance
                  .collection('parties')
                  .doc(widget.partyId);

              partyRef.get().then(
                (docSnapshot) async {
                  if (docSnapshot.exists) {
                    List<dynamic> currentPayments =
                        docSnapshot.get('paymentList');
                    int paidCount = docSnapshot.get('paidCount') ?? 0;
                    // double totalLent = docSnapshot.get('totalLent') ?? 0.0;
                    double totalLent =
                        (docSnapshot.get('totalLent') ?? 0.0).toDouble();

                    // Get the current user document
                    // DocumentSnapshot userSnapshot = await FirebaseFirestore
                    //     .instance
                    //     .collection('users')
                    //     .doc(widget.ownerId)
                    //     .get();
                    // member id

                    // Get the current sumTotalLent value from the user document
                    // double sumTotalLent =
                    //     userSnapshot['sumTotalLent'].toDouble();
                    double lent = 0.0;
                    double paymentAmount = 0.0;
                    for (var payment in currentPayments) {
                      if (payment['id'] == widget.payerId) {
                        payment['isPaid'] = isPaid;
                        // paymentAmount = payment['payment'];
                        paymentAmount = (payment['payment'] as num).toDouble();

                        if (isPaid) {
                          paidCount++;
                          totalLent += paymentAmount;
                          // Add the totalAmount to the sumTotalAmount value
                          // sumTotalLent -= paymentAmount;
                          //
                          final sumTotalDebt = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(payment['id'])
                              .get()
                              .then(
                                  (value) => value['userTotalDebt'].toDouble());

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(payment['id'])
                              .update({
                            'userTotalDebt': sumTotalDebt - paymentAmount,
                          });

                          // Update the sumTotalLent field in the user document
                          final UserModel ownerData =
                              await UserViewModel().fetchUser();
                          print("total lent: $paymentAmount");
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.ownerId)
                              .update({
                            'userTotalLent':
                                ownerData.userTotalLent + paymentAmount,
                          });

                          //Updaet noti
                          if (ownerData.uid != widget.payerId) {
                            NotiViewModel().updateNoti(
                              title: "You bill has been paid",
                              body:
                                  "${ownerData.username} has checked your ${paymentAmount.toStringAsFixed(2)} baht. Bill from ${widget.partyName}",
                              sender: widget.ownerId,
                              receiver: widget.payerId,
                              type: "payment",
                            );
                          }
                        } else if (paidCount > 0) {
                          paidCount--;
                          totalLent -= paymentAmount;
                          // Add the totalAmount to the sumTotalLent value
                          // sumTotalLent += paymentAmount;
                          final sumTotalDebt = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(payment['id'])
                              .get()
                              .then(
                                  (value) => value['userTotalDebt'].toDouble());

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(payment['id'])
                              .update({
                            'userTotalDebt': sumTotalDebt + paymentAmount,
                          });

                          // Update the sumTotalLent field in the user document
                          final UserModel ownerData =
                              await UserViewModel().fetchUser();
                          print("total lent: $paymentAmount");
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.ownerId)
                              .update({
                            'userTotalLent':
                                ownerData.userTotalLent - paymentAmount,
                          });
                        }
                        break;
                      }
                    }
                    partyRef.update(
                      {
                        'paymentList': currentPayments,
                        'paidCount': paidCount,
                        'totalLent': totalLent,
                      },
                    );
                    //get user iD
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
