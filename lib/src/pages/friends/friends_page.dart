import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/friends/add_friend_page.dart';
import 'components/searchBox.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  SearchTerm _searchTerm = const SearchTerm('');

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = SearchTerm(value);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: kDefaultBG,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 70, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
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
              top: 63,
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
              top: 120,
              left: 20,
              right: 20,
              child: SearchBox(
                onChanged: (value) {
                  _onSearchChanged(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: FriendsList(searchTerm: _searchTerm),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendsList extends StatelessWidget {
  final SearchTerm searchTerm;

  final List<String> friends = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Emma',
    'Frank',
    'Grace',
    'Hannah',
    'Ivy',
    'John'
  ];

  FriendsList({required this.searchTerm});

  List<String> _filteredFriends() {
    if (searchTerm.term.isEmpty) {
      return friends;
    }

    final regex = RegExp(searchTerm.term, caseSensitive: false);
    return friends.where((friend) => regex.hasMatch(friend)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFriends = _filteredFriends();

    return ListView.separated(
      itemCount: filteredFriends.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            filteredFriends[index],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.white,
          height: 20,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        );
      },
    );
  }
}

