import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  String _username = "Yovatcha";
  String _email = "yo@gmail.com";
  String _phoneNo = "0956786848";

  void _editUserInfo() async {
    // Show a dialog to edit user info
    final updatedUserInfo = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        // Controller for the text field inputs
        final usernameController = TextEditingController(text: _username);
        final emailController = TextEditingController(text: _email);
        final phoneNoController = TextEditingController(text: _phoneNo);

        return AlertDialog(
          title: const Text("Edit User Info"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              TextField(
                controller: phoneNoController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Dismiss the dialog without updating user info
                Navigator.pop(context, null);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Update the user info and dismiss the dialog
                final newUserInfo = {
                  "username": usernameController.text,
                  "email": emailController.text,
                  "phoneNo": phoneNoController.text,
                };
                Navigator.pop(context, newUserInfo);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    // If user info was updated, update the state with the new values
    if (updatedUserInfo != null) {
      setState(() {
        _username = updatedUserInfo["username"]!;
        _email = updatedUserInfo["email"]!;
        _phoneNo = updatedUserInfo["phoneNo"]!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: kDefaultPadding / 4),
          Container(
            margin: const EdgeInsets.only(left: kDefaultPadding),
            alignment: Alignment.centerLeft,
            child: Text(
              _username,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: kPrimaryColor),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          Row(
            children: [
              Container(child: const Icon(Icons.email)),
              const SizedBox(width: 8),
              Text(_email),
            ],
          ),
          const SizedBox(height: kDefaultPadding),
          Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(width: 8),
              Text(_phoneNo),
            ],
          ),
          const SizedBox(height: kDefaultPadding),
          ElevatedButton(
            onPressed: _editUserInfo,
            child: const Text("Edit"),
          ),
        ],
      ),
    );
  }
}
