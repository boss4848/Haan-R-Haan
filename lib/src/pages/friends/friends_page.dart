import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/friends/add_friend_page.dart';
import 'components/searchBox.dart';
import 'components/FriendsList.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final List<String> _friends = [
    'Alice',
    'Bob',
    'Boss',
    'Charlie',
    'David',
    'Dol',
    'Emma',
    'Fahsai',
    'Frank',
    'Gift',
    'Grace',
    'Hannah',
    'Ivy',
    'John',
    'Yo',
    'Oil',
  ];

  String _searchTerm = '';

  void _onSearchChanged(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
    });
  }

  List<String> _filteredFriends() {
    if (_searchTerm.isEmpty) {
      return _friends;
    }

    final regex = RegExp(_searchTerm, caseSensitive: false);
    return _friends.where((friend) => regex.hasMatch(friend)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFriends = _filteredFriends();

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: kDefaultBG,
            ),
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 50, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Friends",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 45,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFriendPage()),
                    );
                  },
                ),
              ),
              Positioned(
                  top: 100,
                  left: 20,
                  right: 20,
                  child: SearchBox(onChanged: _onSearchChanged)),
              Positioned(
                top: 150,
                left: 0,
                right: 0,
                bottom: 0,
                child: FriendsList(
                  friends: filteredFriends,
                  onFriendSelected: (friend) {
                    // Do something when a friend is selected
                  },
                ),
              ),
            ])));
  }
}
