import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/select_food/select_food_page.dart';
import 'package:haan_r_haan/src/pages/select_member/widgets/button_outlined.dart';
import 'package:haan_r_haan/src/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';
import '../../../constant/constant.dart';
import '../../models/party_model.dart';
import '../../models/user_model.dart';
import '../../utils/format.dart';
import '../../viewmodels/friend_view_model.dart';
import '../../widgets/button.dart';
import 'widgets/member_item.dart';
import 'widgets/qr_code.dart';

class SelectMemberPage extends StatefulWidget {
  final PartyModel party;
  const SelectMemberPage({
    super.key,
    required this.party,
  });

  @override
  State<SelectMemberPage> createState() => _SelectMemberPageState();
}

class _SelectMemberPageState extends State<SelectMemberPage> {
  final _firestore = FirebaseFirestore.instance;
  ValueNotifier<List<UserModel>> selectedFriends =
      ValueNotifier<List<UserModel>>([]);
  ValueNotifier<bool> selectAll = ValueNotifier<bool>(false);

  void toggleSelectedFriend(UserModel friend) {
    if (selectedFriends.value.contains(friend)) {
      selectedFriends.value.remove(friend);
    } else {
      selectedFriends.value.add(friend);
    }
    print("selectedFriends: ${selectedFriends.value}");

    selectedFriends.notifyListeners();
  }

  void _handleSelectAll(List<UserModel> friends) {
    if (selectAll.value) {
      selectedFriends.value.clear();
      selectAll.value = false;
    } else {
      selectedFriends.value = List<UserModel>.from(friends);
      selectAll.value = true;
    }
    selectedFriends.notifyListeners();
  }

  Future<void> onDeleteParty() async {
    loadingDialog(context);
    await _firestore.collection('parties').doc(widget.party.partyID).delete();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<void> onSubmit() async {
    if (selectedFriends.value.isEmpty) {
      return;
    }
    loadingDialog(context);
    // Fetch the current members
    DocumentSnapshot docSnapshot =
        await _firestore.collection('parties').doc(widget.party.partyID).get();
    List<dynamic> currentMembers = List<dynamic>.from(docSnapshot['members']);

    // Construct a new list of members, preserving the first member and adding the selected friends
    List<dynamic> newMembers = [];
    newMembers.add(currentMembers[0]); // Add the first member
    newMembers.addAll(selectedFriends.value
        .map((e) => e.uid)
        .toList()); // Add the selected friends

    // Update the document with the new list of members
    await _firestore.collection('parties').doc(widget.party.partyID).update({
      'members': newMembers,
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SelectFoodPage(
        party: widget.party,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildContent(context),
          _buildBanner(context),
        ],
      ),
    );
  }

  Stack _buildBanner(BuildContext context) {
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
                      Text(
                        formatTimestamp(widget.party.createdAt),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
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
                  child: Row(
                    children: [
                      ValueListenableBuilder<List<UserModel>>(
                        valueListenable: selectedFriends,
                        builder: (context, value, child) {
                          return _buildStatus(
                            context: context,
                            sub: "SELECTED",
                            value: value.length,
                            unit: "Friends",
                          );
                        },
                      ),
                      Container(
                        width: 1.2,
                        height: 50,
                        color: greyBackgroundColor,
                      ),
                      _buildStatus(
                        context: context,
                        sub: "JOIN BY LINK",
                        value: 0,
                        unit: "Members",
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

  Container _buildContent(BuildContext context) {
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
              Text(
                "Select your friends to join",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<UserModel>>(
                stream: Provider.of<FriendViewModel>(context).friendListStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.isEmpty) {
                    return Container();
                    // return const Center(child: Text('No friends.'));
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
                                onToggleSelected: (friend) =>
                                    toggleSelectedFriend(friend),
                                selectedFriends: selectedFriends,
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
              // Wrap(
              //   spacing: 8,
              //   runSpacing: 8,
              //   children: const [
              //     SizedBox(
              //       width: double.infinity,
              //       child: MemberItem(
              //         name: "Select all",
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              Text(
                "Or scan QR code to join",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: boxShadow_1,
                child: QRCode(qrData: widget.party.partyID),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: ButtonOutlined(
                  onPressed: () {},
                  buttonName: "Save Image",
                  icon: CupertinoIcons.arrow_down_to_line,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Button(() {
                  onSubmit();
                }, "Next"),
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
          horizontal: 20,
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
