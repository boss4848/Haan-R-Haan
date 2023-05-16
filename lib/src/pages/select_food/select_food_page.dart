import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/models/food_model.dart';
import 'package:haan_r_haan/src/pages/select_member/widgets/member_item.dart';
import 'package:haan_r_haan/src/viewmodels/noti_view_model.dart';
import 'package:haan_r_haan/src/widgets/input_box.dart';
import 'package:haan_r_haan/src/widgets/title.dart';
import '../../../constant/constant.dart';
import 'package:intl/intl.dart';
import '../../models/party_model.dart';
import '../../models/user_model.dart';
import '../../widgets/button.dart';
import 'widgets/food_item.dart';

class SelectFoodPage extends StatefulWidget {
  final PartyModel party;
  const SelectFoodPage({
    required this.party,
    super.key,
  });

  @override
  State<SelectFoodPage> createState() => _SelectFoodPageState();
}

class _SelectFoodPageState extends State<SelectFoodPage> {
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
    List<String> eaters = members.map((e) => e.uid).toList();
    print("members: $members");
    final newFood = FoodModel(
      foodName: foodNameController.text,
      foodPrice: double.parse(priceController.text),
      eaters: eaters,
    );

    foods.value = [...foods.value, newFood];

    foodNameController.clear();
    priceController.clear();
    resetSelectedMembers();
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
    // print("selectedMembers: ${selectedMembers.value}");

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
      UserModel newMember = UserModel.fromFirestore(doc);

      return newMember;
    }).toList();

    List<UserModel> membersDetail = await Future.wait(memberFutures);
    print("membersDetail: $membersDetail");

    return membersDetail;
  }

  Future<void> onCreateParty() async {
    // Calculate the total amount
    double totalAmount =
        foods.value.fold(0, (sum, food) => sum + food.foodPrice);

    List<Map<String, dynamic>> memberPayments = [];
    for (var food in foods.value) {
      double pricePerEater = food.foodPrice / food.eaters.length;
      for (var eater in food.eaters) {
        int existingIndex = memberPayments
            .indexWhere((mp) => mp.containsKey('id') && mp['id'] == eater);
        if (existingIndex >= 0) {
          memberPayments[existingIndex]['payment'] =
              memberPayments[existingIndex]['payment'] + pricePerEater;
        } else {
          memberPayments.add({
            'id': eater,
            // 'payerID': food.eaters[0].uid,
            'payment': pricePerEater,
            'isPaid': false,
          });

          // Update the sumTotalDept
          FirebaseFirestore.instance.collection('users').doc(eater).update({
            'userTotalDebt': FieldValue.increment(pricePerEater),
          });

          //Update noti
          //Update noti
          NotiViewModel().updateNoti(
            title: "New Expense Added",
            body:
                "Hey there! An expense of ${pricePerEater.toStringAsFixed(2)} has been added to your shared bill. Kindly check it out and settle your part when you can. Thanks!",
            sender: FirebaseAuth.instance.currentUser!.uid,
            receiver: eater,
            type: "expense",
          );
        }
      }
    }

    // Update the Firestore document
    FirebaseFirestore.instance
        .collection('parties')
        .doc(widget.party.partyID)
        .update({
      "foodList": foods.value.map((food) => food.toFirestore()).toList(),
      "totalAmount": totalAmount,
      "isDraft": false,
      "updatedAt": Timestamp.now(),
      "paymentList": memberPayments,
      "paidCount": 0,
      "totalLent": -totalAmount,
      // 'sumTotalLent': 0.1,
    });
    //get user iD
    String userID = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then(
          (value) => value.docs[0].id,
        );

    // Get the current user document
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    // Get the current sumTotalLent value from the user document
    double sumTotalLent = userSnapshot['userTotalLent'].toDouble();

    // Add the totalAmount to the sumTotalLent value
    sumTotalLent += (-totalAmount);
    // Update the sumTotalLent field in the user document
    FirebaseFirestore.instance.collection('users').doc(userID).update({
      'userTotalLent': sumTotalLent.toDouble(),
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
            .doc(widget.party.partyID)
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
          return Stack(
            children: [
              _buildContent(
                context,
                snapshot.data?["members"].cast<String>().toList(),
              ),
              _buildBanner(
                context,
                snapshot.data?["partyName"],
                snapshot.data?["ownerName"],
                snapshot.data?["partyDesc"],
                snapshot.data?["members"].length,
                snapshot.data?["membersJoinedByLink"].length,
                snapshot.data?["createdAt"],
              ),
            ],
          );
        },
      ),
    );
  }

  Stack _buildBanner(
    BuildContext context,
    String partyName,
    String ownerName,
    String desc,
    int members,
    int membersJoinedByLink,
    Timestamp createAt,
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
                                fontSize: 19, color: kSecondaryColor),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            formatDateTime(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                  child: Row(
                    children: [
                      _buildStatus(
                        context: context,
                        sub: "IN THE PARTY",
                        value: members,
                        unit: "Members",
                      ),
                      Container(
                        width: 1.2,
                        height: 50,
                        color: greyBackgroundColor,
                      ),
                      _buildStatus(
                        context: context,
                        sub: "JOIN BY LINK",
                        value: membersJoinedByLink,
                        unit: "Members",
                      ),
                      Container(
                        width: 1.2,
                        height: 50,
                        color: greyBackgroundColor,
                      ),
                      ValueListenableBuilder(
                        valueListenable: foods,
                        builder: (context, value, child) {
                          return _buildStatus(
                            context: context,
                            sub: "ADDED",
                            value: value.length,
                            unit: "Foods",
                          );
                        },
                      ),
                    ],
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
    List<String> members,
  ) {
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
              const SizedBox(height: 280),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: InputBox(
                      label: "Food name",
                      controller: foodNameController,
                      errorText: "",
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: InputBox(
                      label: "Price",
                      controller: priceController,
                      errorText: "",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(80, 50),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        addFood();
                      },
                      child: const Text("Add"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Who ate this food?",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<UserModel>>(
                future: fetchMemberDetails(members),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.isEmpty) {
                    // return Container();
                    return const Center(child: Text('No friends.'));
                  } else {
                    final friends = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            friends.length,
                            (index) {
                              return MemberItem(
                                friend: friends[index],
                                onToggleSelected: (member) =>
                                    toggleSelectedMember(member),
                                selectedFriends: selectedMembers,
                                onUpdateSelectAll: () {
                                  selectAll.value = false;
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<bool>(
                            valueListenable: selectAll,
                            builder: (context, value, child) {
                              return InkWell(
                                onTap: () => _handleSelectAll(snapshot.data!),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: value
                                        ? greenPastelColor
                                        : redPastelColor,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        value
                                            ? CupertinoIcons.minus
                                            : CupertinoIcons.add,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        "Select all",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    );
                  }
                },
              ),
              ValueListenableBuilder(
                valueListenable: foods,
                builder: (context, value, child) {
                  return TitleBar(
                    title: "Food List",
                    subTitle: "${value.length} foods",
                    isNoPadding: true,
                  );
                },
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                  valueListenable: foods,
                  builder: (context, value, child) {
                    return Column(
                      children: List.generate(
                        foods.value.length,
                        (index) {
                          print('eaters test: ${foods.value[index].eaters}');
                          return FoodItem(
                            food: foods.value[index],
                            // foodName: foods.value[index].foodName,
                            // foodPrice: foods.value[index].foodPrice,
                            // eaters: foods.value[index].eaters,
                            onDeleted: () => deleteFood(foods.value[index]),
                          );
                        },
                      ),
                    );
                  }),
              // const FoodItem(),
              // const SizedBox(height: 10),
              // const FoodItem(),
              // const SizedBox(height: 10),
              // const FoodItem(),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Button(() {
                  onCreateParty();

                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Navigator.pop(context);
                }, "Create Party"),
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
