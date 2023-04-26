import 'package:flutter/material.dart';

class FriendsList extends StatelessWidget {
  final List<String> friends;
  final void Function(String) onFriendSelected;

  const FriendsList({
    required this.friends,
    required this.onFriendSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return const Center(
        child: Text("No Friends"),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return ListTile(
            title: Text(
              friend,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
            onTap: () {
              onFriendSelected(friend);
            },
          );
        },
      ),
    );
  }
}
