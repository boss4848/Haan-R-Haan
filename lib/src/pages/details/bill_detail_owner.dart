import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/models/billDetail_models.dart';
import 'package:haan_r_haan/src/models/food_model.dart';
import 'package:haan_r_haan/src/pages/select_member/widgets/member_item.dart';
import 'package:haan_r_haan/src/widgets/input_box.dart';
import 'package:haan_r_haan/src/widgets/shadow_container.dart';
import 'package:haan_r_haan/src/widgets/title.dart';
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';
import '../../../constant/constant.dart';
import 'package:intl/intl.dart';

import '../../models/user_model_draft.dart';
import '../bill_detail/owner_bill_detail/widgets/promptPay.dart';
import '../select_food/widgets/food_item.dart';
import '../select_food/widgets/member.dart';
import '../select_member/widgets/qr_code.dart';

class BillDetailOwnerPage extends StatefulWidget {
  final String partyID;
  const BillDetailOwnerPage({
    this.partyID = "",
    super.key,
  });

  @override
  State<BillDetailOwnerPage> createState() => _BillDetailOwnerPageState();
}

class _BillDetailOwnerPageState extends State<BillDetailOwnerPage> {
  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('EEE dd MMM HH:mm');
    return formatter.format(dateTime);
  }

  ValueNotifier<List<FoodModel>> foods = ValueNotifier<List<FoodModel>>([]);
  ValueNotifier<List<UserModel>> selectedMembers =
      ValueNotifier<List<UserModel>>([]);
  ValueNotifier<bool> selectAll = ValueNotifier<bool>(false);

  void addFood() {
    if (foodNameController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedMembers.value.isEmpty) return;
    List<UserModel> members = [...selectedMembers.value];
    print("members: $members");
    final newFood = FoodModel(
      foodName: foodNameController.text,
      foodPrice: double.parse(priceController.text),
      eaters: members,
    );
    //print value off newFood
    print("newFood: $newFood");
    print("newFood.foodName: ${newFood.foodName}");
    print("newFood.foodPrice: ${newFood.foodPrice}");
    print("newFood.eaters: ${newFood.eaters}");
    for (var i = 0; i < newFood.eaters.length; i++) {
      print("newFood.eaters[i].name: ${newFood.eaters[i].username}");
    }

    foods.value = [...foods.value, newFood];

    foodNameController.clear();
    priceController.clear();
    // selectedMembers.value.clear();
    // selectAll.value = false;
    resetSelectedMembers();
    print("members check: $members");
  }

  void deleteFood(FoodModel food) {
    foods.value.remove(food);
    foods.notifyListeners();
  }

  void toggleSelectedMember(UserModel member) {
    if (selectedMembers.value.contains(member)) {
      selectedMembers.value.remove(member);
    } else {
      selectedMembers.value.add(member);
    }
    print("selectedMembers: ${selectedMembers.value}");

    selectedMembers.notifyListeners();
  }

  void resetSelectedMembers() {
    if (selectAll.value) {
      _handleSelectAll(selectedMembers.value);
    } else {
      selectedMembers.value.clear();
      selectedMembers.notifyListeners(); // Notify listeners to update the UI
    }
    selectAll.value = false;
  }

  void _handleSelectAll(List<UserModel> friends) {
    if (selectAll.value) {
      selectedMembers.value.clear();
      selectAll.value = false;
    } else {
      selectedMembers.value = List<UserModel>.from(friends);
      selectAll.value = true;
    }
    selectedMembers.notifyListeners();
  }

  Future<List<UserModel>> fetchMemberDetails(List<String> members) async {
    print("members: $members");

    List<Future<UserModel>> memberFutures = members.map((member) async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: member)
          .get();

      DocumentSnapshot doc = querySnapshot.docs[0];
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      UserModel newMember = UserModel(
        id: data['uid'] ?? '',
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        friendList: [],
        phoneNumber: data['phoneNumber'] ?? '',
      );

      return newMember;
    }).toList();

    List<UserModel> membersDetail = await Future.wait(memberFutures);
    print("membersDetail: $membersDetail");

    return membersDetail;
  }

  void onCreateParty() {
    // Calculate the total amount
    double totalAmount =
        foods.value.fold(0, (sum, food) => sum + food.foodPrice);

    // Calculate each member's payment and set isPaid to false
    Map<String, Map<String, dynamic>> memberPayments = {};
    for (var food in foods.value) {
      double pricePerEater = food.foodPrice / food.eaters.length;
      for (var eater in food.eaters) {
        if (memberPayments.containsKey(eater.id)) {
          memberPayments[eater.id]!['payment'] =
              memberPayments[eater.id]!['payment'] + pricePerEater;
        } else {
          memberPayments[eater.id] = {
            'payerID': food.eaters[0].id,
            'payment': pricePerEater,
            'isPaid': false,
          };
        }
      }
    }

    // Update the Firestore document
    FirebaseFirestore.instance
        .collection('parties')
        .doc(widget.partyID)
        .update({
      "foods": foods.value.map((food) => food.toJson()).toList(),
      "totalAmount": totalAmount,
      "isDraft": false,
      "updatedAt": Timestamp.now(),
      "payments": memberPayments,
    });
  }

  List<bool> selectedFriends = List.filled(11, false);
  final foodNameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('parties')
            .doc(widget.partyID)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
          return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('email',
                      isEqualTo: FirebaseAuth.instance.currentUser!.email)
                  .get()
                  .then((value) => value.docs[0].id),
              builder: (context, currentUser) {
                return Stack(
                  children: [
                    _buildContent(
                      context,
                      snapshot.data?["members"].cast<String>().toList(),
                      snapshot.data,
                      currentUser,
                    ),
                    _buildBanner(
                      context,
                      snapshot.data?["partyName"],
                      snapshot.data?["ownerName"],
                      snapshot.data?["ownerID"],
                      snapshot.data?["partyDesc"],
                      widget.partyID,
                      snapshot.data?["members"].length,
                      snapshot.data?["createdAt"],
                      snapshot.data?["totalAmount"],
                      currentUser,
                    ),
                  ],
                );
              });
        },
      ),
    );
  }

  Stack _buildBanner(
    BuildContext context,
    String partyName,
    String ownerName,
    String ownerID,
    String desc,
    String partyID,
    int members,
    Timestamp createAt,
    double totalAmount,
    AsyncSnapshot<String> currentUser,
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
                        partyName,
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
                            ownerName,
                            style: const TextStyle(
                              fontSize: 19,
                              color: kSecondaryColor,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            formatDateTime(createAt.toDate()),
                            style: const TextStyle(
                              fontSize: 11,
                              color: kSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (ownerID == currentUser.data)
                    GestureDetector(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('parties')
                            .doc(widget.partyID)
                            .delete();
                        // Navigator.pop(context); // remove the dialog
                        // if (Navigator.canPop(context)) {
                        //   // remove the party page only if it exists in the stack
                        Navigator.pop(context);
                        // }
                      },
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
                    desc,
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
                          .doc(partyID)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }

                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        int paidCount = data['paidCount'] ?? 0;
                        double totalLent = (data['totalLent'] ?? 0).toDouble();

                        return Row(
                          children: [
                            _buildStatus(
                              context: context,
                              sub: "IN THE PARTY",
                              value: members,
                              unit: "Friends",
                            ),
                            Container(
                              width: 1.2,
                              height: 50,
                              color: greyBackgroundColor,
                            ),
                            _buildStatus(
                              context: context,
                              sub: "TOTAL AMOUNT",
                              value: totalAmount.ceil(),
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
                              value: totalLent.ceil(),
                              unit: "฿",
                            ),
                          ],
                        );
                      }),
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
    List<String> members,
    DocumentSnapshot<Map<String, dynamic>>? parties,
    AsyncSnapshot<String> currentUser,
  ) {
    final payments = parties?.data()?['payments'] as List<dynamic>?;
    double amount = 0.0;
    for (var i = 0; i < payments!.length; i++) {
      if (payments[i]['id'] == currentUser.data) {
        amount = payments[i]['payment'].toDouble();
      }
    }

    // final amount = currentUserPayment;
    // currentUserPayment != null ? currentUserPayment['payment'] : 0.0;

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
                subTitle: "${parties?['foods'].length} foods",
                isNoPadding: true,
              ),
              Column(
                children: List.generate(parties?['foods'].length, (index) {
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
                              parties?['foods'][index]['foodName'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                            Text(
                              "${parties?['foods'][index]['foodPrice']} Baht",
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
                            parties?['foods'][index]['eaters'].length,
                            (i) {
                              // print(parties?['foods'][index]['eaters'][index]);
                              return FutureBuilder(
                                future: fetchMemberDetails(
                                  [parties?['foods'][index]['eaters'][i]],
                                ),
                                builder: (context, snapshot) {
                                  return Member(
                                    name:
                                        snapshot.data?[0].username ?? 'Loading',
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
              TitleBar(
                title: "Who has paid?",
                subTitle: "0/${members.length} members",
                isNoPadding: true,
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 20, left: 5),
                decoration: boxShadow_1,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('parties')
                      .doc(widget.partyID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      final parties = snapshot.data as DocumentSnapshot;
                      final payments = parties.get('payments') as List;
                      return Column(
                        children: payments.map((payerPayment) {
                          return Row(
                            children: [
                              PaymentCheckbox(
                                isOwner: parties['ownerID'] == currentUser.data,
                                isPaid: payerPayment['isPaid'] ?? false,
                                payerId: payerPayment['id'],
                                partyId: widget.partyID,
                              ),
                              FutureBuilder(
                                future:
                                    fetchMemberDetails([payerPayment['id']]),
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data?[0].username ?? 'Loading',
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
                subTitle: parties?['ownerID'] == currentUser.data
                    ? '(ไม่ระบุจำนวนเงิน)'
                    : '(ระบุจำนวนเงิน)',
                isNoPadding: true,
              ),
              Container(
                decoration: boxShadow_1,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: QRCodeGenerate(
                  promptPayId: parties?['promptpay'],
                  isShowAmountDetail: false,
                  amount:
                      parties?['ownerID'] == currentUser.data ? 0.0 : amount,
                  promptPayDetailCustom: Column(
                    children: [
                      Text(
                        parties?['partyName'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(
                        "Promptpay (${parties?['promptpay']})",
                        style: const TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                        ),
                      ),
                      if (parties?['ownerID'] != currentUser.data)
                        Text(
                          "You need to pay ${amount.toStringAsFixed(2)} baht",
                          style: const TextStyle(
                            fontSize: 16,
                            color: kPrimaryColor,
                          ),
                        ),
                      Text(
                        "${parties?['ownerName']}",
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

  const PaymentCheckbox({
    super.key,
    required this.isOwner,
    required this.isPaid,
    required this.payerId,
    required this.partyId,
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
                (docSnapshot) {
                  if (docSnapshot.exists) {
                    List<dynamic> currentPayments = docSnapshot.get('payments');
                    int paidCount = docSnapshot.get('paidCount') ?? 0;
                    // double totalLent = docSnapshot.get('totalLent') ?? 0.0;
                    double totalLent =
                        (docSnapshot.get('totalLent') ?? 0.0).toDouble();

                    double paymentAmount = 0.0;
                    for (var payment in currentPayments) {
                      if (payment['id'] == widget.payerId) {
                        payment['isPaid'] = isPaid;
                        // paymentAmount = payment['payment'];
                        paymentAmount = (payment['payment'] as num).toDouble();

                        if (isPaid) {
                          paidCount++;
                          totalLent += paymentAmount;
                        } else if (paidCount > 0) {
                          paidCount--;
                          totalLent -= paymentAmount;
                        }
                        break;
                      }
                    }
                    partyRef.update(
                      {
                        'payments': currentPayments,
                        'paidCount': paidCount,
                        'totalLent': totalLent,
                      },
                    );
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
