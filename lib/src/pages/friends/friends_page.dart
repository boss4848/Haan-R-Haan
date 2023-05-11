import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/widgets/title.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/user_model_draft.dart';
import '../../viewmodels/friend_view_model.dart';
import '../../viewmodels/user_view_model_draft.dart';
import 'widgets/custom_appbar.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _scrollController = TrackingScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _searchResults = [];

  void onSendFriendRequest(String receiverID) async {
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final friendViewModel =
          Provider.of<FriendViewModel>(context, listen: false);
      final currentUserID = userViewModel.currentUserData?.id ?? "";
      print("receiver: $receiverID");
      print("sender: $currentUserID");

      await friendViewModel.sendFriendRequest(currentUserID, receiverID);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request sent!')),
      );
      setState(() {
        _searchResults = [];
        _searchController.clear();
      });
    } catch (e) {
      // Show error message if there is an issue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void onAcceptFriendRequest(
    String requestId,
    String senderId,
    String receiverId,
  ) async {
    final friendViewModel =
        Provider.of<FriendViewModel>(context, listen: false);
    await friendViewModel.acceptFriendRequest(
      requestId,
      senderId,
      receiverId,
    );
    // Fetch updated friend requests
    await friendViewModel.fetchFriendRequests(receiverId);
  }

  void onDeclineFriendRequest(
    String requestId,
    String receiverId,
  ) async {
    final friendViewModel =
        Provider.of<FriendViewModel>(context, listen: false);
    await friendViewModel.declineFriendRequest(requestId);
    // Fetch updated friend requests
    await friendViewModel.fetchFriendRequests(receiverId);
  }

  void onRemoveFriend(String friendUserId) async {
    try {
      final friendViewModel =
          Provider.of<FriendViewModel>(context, listen: false);
      final currentUserId =
          Provider.of<UserViewModel>(context, listen: false).userID;

      await friendViewModel.removeFriend(currentUserId, friendUserId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend removed!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formatted = DateFormat('EEE dd MMM HH:mm').format(dateTime);
    return formatted;
  }

  //Handle scroll
  late Color _backgroundColor;
  late double _opacity;
  late double _offset;
  @override
  void initState() {
    _backgroundColor = Colors.transparent;
    _opacity = 0.0;
    _offset = 0.0;

    _scrollController.addListener(_onScroll);

    final friendViewModel =
        Provider.of<FriendViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final userId =
        userViewModel.currentUserData?.id ?? "nBuVKzmUjKUthSi6QziTafcbY0h2";
    friendViewModel.fetchFriendRequests(userId);
    friendViewModel.fetchFriendList(userId);

    friendViewModel.listenForNewFriendRequests(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    height: 170,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: kDefaultBG,
                    ),
                  ),
                  CustomAppBar(
                    controller: _searchController,
                    onSubmitted: (query) {
                      userViewModel.searchUsersByUsername(query).then((value) {
                        setState(() {
                          _searchResults = value;
                        });
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_searchResults.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 10,
                  ),
                  decoration: boxShadow_1,
                  child: Column(
                    children: [
                      if (_searchResults.isNotEmpty)
                        for (var i = 0; i < _searchResults.length; i++)
                          _buildUserItem(
                            userModel: _searchResults[i],
                          ),
                    ],
                  ),
                ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream:
                    Provider.of<FriendViewModel>(context).friendRequestsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.isEmpty) {
                    return Container();
                    // return const Center(child: Text('No friend requests.'));
                  } else {
                    final requests = snapshot.data!;

                    return Column(
                      children: [
                        TitleBar(
                          title: "Friend Request",
                          subTitle: "${requests.length} requests",
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                            bottom: 10,
                          ),
                          decoration: boxShadow_1,
                          child: Column(
                            children: List.generate(
                              requests.length,
                              (index) => _buildFriendRequestItem(
                                requestId: requests[index]['id'],
                                receiverId: requests[index]['receiverID'],
                                senderId: requests[index]['senderID'],
                                userModel: requests[index]['senderDetails'],
                                date: requests[index]['timestamp'],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
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
                      children: [
                        TitleBar(
                          title: "Friends",
                          subTitle: "${friends.length} friends",
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                            bottom: 10,
                          ),
                          decoration: boxShadow_1,
                          child: Column(
                            children: List.generate(
                              friends.length,
                              (index) => _buildFriendItem(
                                username: friends[index].username,
                                email: friends[index].email,
                                id: friends[index].id,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Container(
          color: _backgroundColor,
          // height: 160,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      //refresh
                      setState(() {
                        _searchResults.clear();
                        _searchController.clear();
                      });

                      final friendViewModel =
                          Provider.of<FriendViewModel>(context, listen: false);
                      final userViewModel =
                          Provider.of<UserViewModel>(context, listen: false);
                      final userId = userViewModel.currentUserData?.id ??
                          "nBuVKzmUjKUthSi6QziTafcbY0h2";
                      friendViewModel.fetchFriendRequests(userId);
                      friendViewModel.fetchFriendList(userId);
                    },
                    child: const Text(
                      "Friends",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: kSecondaryColor),
                    ),
                  ),
                  const Icon(
                    Icons.notifications,
                    size: 36,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildFriendRequestItem({
    required String requestId,
    required String senderId,
    required String receiverId,
    required DateTime date,
    required UserModel userModel,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userModel.username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                formatTimestamp(Timestamp.fromDate(date)),
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildButton(
            buttonName: "Accept",
            backgroundColor: kPrimaryColor,
            onPressed: () {
              print('accept');
              onAcceptFriendRequest(requestId, senderId, receiverId);
              // handleOnAccept(docID);
            },
          ),
          const SizedBox(width: 8),
          _buildButton(
            buttonName: "Decline",
            backgroundColor: redPastelColor,
            onPressed: () {
              print('decline');
              onDeclineFriendRequest(requestId, receiverId);
              // handleOnDecline(docID);
            },
          ),
        ],
      ),
    );
  }

  Padding _buildUserItem({
    // String docID = "",
    // String? username,
    // String? email,
    required UserModel userModel,
    // DocumentSnapshot? documentSnapshot,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userModel.username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                userModel.email,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildButton(
            buttonName: "Add",
            backgroundColor: kPrimaryColor,
            onPressed: () {
              // handleAddFriend(documentSnapshot!);
              onSendFriendRequest(userModel.id);
            },
            // onPressed: () => addFriend(),
          ),
        ],
      ),
    );
  }

  Padding _buildFriendItem({
    required username,
    required email,
    required id,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                email,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildButton(
            buttonName: "Remove",
            backgroundColor: redPastelColor,
            onPressed: () {
              onRemoveFriend(id);
            },
          ),
        ],
      ),
    );
  }

  TextButton _buildButton({
    required String buttonName,
    required Color backgroundColor,
    required Function()? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size(80, 32),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size(80, 32),
        ),
        backgroundColor: MaterialStateProperty.all(
          backgroundColor,
        ),
      ),
      child: Text(
        buttonName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }

  _onScroll() {
    final scrollOffset = _scrollController.offset;
    if (scrollOffset >= _offset && scrollOffset > 5) {
      _opacity = (_opacity + 0.02).clamp(0.0, 1.0);
      _offset = scrollOffset;
    } else if (scrollOffset < 100) {
      _opacity = (_opacity - 0.02).clamp(0.0, 1.0);
    }

    setState(() {
      if (scrollOffset <= 0) {
        _offset = 0.0;
        _opacity = 0.0;
      }
      _backgroundColor = kPrimaryColor.withOpacity(_opacity);
    });
  }
}
