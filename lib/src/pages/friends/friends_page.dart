import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/models/friend_request_model.dart';
import 'package:haan_r_haan/src/pages/friends/widgets/friend_request_item.dart';
import 'package:haan_r_haan/src/pages/friends/widgets/user_item.dart';
import 'package:haan_r_haan/src/viewmodels/friend_view_model.dart';
import 'package:haan_r_haan/src/widgets/show_more.dart';
import 'package:haan_r_haan/src/widgets/title.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../utils/format.dart';
import '../../viewmodels/user_view_model.dart';
import 'widgets/custom_appbar.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _scrollController = TrackingScrollController();
  final searchController = TextEditingController();
  List<UserModel> _searchResults = [];
  //Handle scroll
  late Color _backgroundColor;
  late double _opacity;
  late double _offset;

  @override
  initState() {
    _backgroundColor = Colors.transparent;
    _opacity = 0.0;
    _offset = 0.0;

    _scrollController.addListener(_onScroll);
    // userData = await UserViewModel().fetchUser();
    super.initState();
  }

  onRemoveRequest(String friendID) async {
    final friendViewModel = FriendViewModel();
    final userData = await UserViewModel().fetchUser();

    try {
      friendViewModel.removeFriendRequest(
        userData.uid,
        friendID,
      );
    } catch (e) {
      rethrow;
    }
  }

  onSendRequest(String friendID) async {
    final friendViewModel = FriendViewModel();
    final userData = await UserViewModel().fetchUser();
    try {
      await friendViewModel.sendFriendRequest(
        userData.uid,
        friendID,
      );

      setState(() {
        _searchResults = [];
        searchController.clear();
      });
    } catch (e) {
      rethrow;
    }
  }

  // void onAcceptFriendRequest(
  //   String requestId,
  //   String senderId,
  //   String receiverId,
  // ) async {

  //   await
  // }

  @override
  Widget build(BuildContext context) {
    final friendViewModel = Provider.of<FriendViewModel>(
      context,
      listen: false,
    );
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
                    controller: searchController,
                    onSubmitted: (query) {
                      friendViewModel
                          .searchUsers(username: query)
                          .then((value) {
                        setState(() {
                          _searchResults = value;
                        });
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              //Search Result
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
                          UserItem(
                            user: _searchResults[i],
                            handleFunction: () {
                              onSendRequest(
                                _searchResults[i].uid,
                              );
                            },
                            buttonName: "Add",
                          ),
                    ],
                  ),
                ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: friendViewModel.pendingRequestsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.isEmpty) {
                    return Container();
                    // return const Center(child: Text('No friend friends.'));
                  } else {
                    final requests = snapshot.data!;

                    return Column(
                      children: [
                        TitleBar(
                          title: "Pending Request",
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
                              (index) => UserItem(
                                user: requests[index]['receiverDetails'],
                                handleFunction: () {
                                  onRemoveRequest(
                                    requests[index]['receiverDetails'].uid,
                                  );
                                },
                                buttonName: "Cancel",
                                buttonColor: redPastelColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: friendViewModel.friendRequestsStream,
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
                            children: List.generate(requests.length, (index) {
                              final FriendRequestModel requestModel =
                                  requests[index]['request'];
                              return FriendRequestItem(
                                friendRequestModel: requestModel,
                                onAcceptFriendRequest: () {
                                  friendViewModel.acceptFriendRequest(
                                    requestModel.id,
                                    requestModel.senderID,
                                    requestModel.receiverID,
                                  );
                                },
                                onDeclineFriendRequest: () {
                                  friendViewModel.declineFriendRequest(
                                    requestModel.id,
                                  );
                                },
                                senderUserModel: requests[index]
                                    ['senderDetails'],
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              StreamBuilder<List<UserModel>>(
                stream: friendViewModel.friendListStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.isEmpty) {
                    return Container();
                    // return const Center(child: Text('No friend requests.'));
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
                              (index) => UserItem(
                                user: friends[index],
                                handleFunction: () {
                                  friendViewModel.removeFriend(
                                    friends[index].uid,
                                  );
                                },
                                buttonName: "Remove",
                                buttonColor: redPastelColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
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
                children: const [
                  Text(
                    "Friends",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: kSecondaryColor),
                  ),
                  Icon(
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
              // onAcceptFriendRequest(requestId, senderId, receiverId);
              // handleOnAccept(docID);
            },
          ),
          const SizedBox(width: 8),
          _buildButton(
            buttonName: "Decline",
            backgroundColor: redPastelColor,
            onPressed: () {
              print('decline');
              // onDeclineFriendRequest(requestId, receiverId);
              // handleOnDecline(docID);
            },
          ),
        ],
      ),
    );
  }

  Padding _buildFriendItem({
    String? username,
    String? email,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username ?? "Username",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                email ?? "user_email@mail.com",
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  TextButton _buildButton({
    required String buttonName,
    required Color backgroundColor,
    required Function onPressed,
  }) {
    return TextButton(
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
      onPressed: () => onPressed,
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
