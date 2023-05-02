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
  // String _username = userData[userName];
  // String _email = "yo@gmail.com";
  // String _phoneNo = "0956786848";

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            "Edit User Info",
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: kPrimaryColor),
          ),
          content: Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(
                        Icons.person_2_rounded,
                        color: kPrimaryColor,
                      ),
                      hintText: 'Your Username',
                      fillColor: kPrimaryColor),
                ),
                TextField(
                  controller: phoneNoController,
                  decoration: const InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(
                        Icons.phone_android_rounded,
                        color: kPrimaryColor,
                      ),
                      hintText: 'Your Phone No.',
                      fillColor: kPrimaryColor),
                ),
              ],
            ),
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
      decoration: const BoxDecoration(
        color: kSecondaryColor,
        boxShadow: [kDefaultShadow],
        //borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: Column(
          children: [
            const SizedBox(height: kDefaultPadding / 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: greyTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(color: greyTextColor),
                  ),
                  onPressed: _editUserInfo,
                  child: const Icon(
                    Icons.edit,
                    color: greyTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: kDefaultPadding),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color:
                              greyTextColor, // Replace with your desired background color
                          shape: BoxShape.circle),
                      child: const Icon(
                        Icons.email,
                        color: kSecondaryColor,
                      )),
                ),
                const SizedBox(width: 8),
                Text(
                  _email,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: greyTextColor),
                ),
              ],
            ),
            const SizedBox(height: kDefaultPadding),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color:
                              greyTextColor, // Replace with your desired background color
                          shape: BoxShape.circle),
                      child: const Icon(
                        Icons.phone_android,
                        color: kSecondaryColor,
                      )),
                ),
                const SizedBox(width: 8),
                Text(
                  _phoneNo,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: greyTextColor),
                ),
              ],
            ),
            const SizedBox(height: kDefaultPadding),
          ],
        ),
      ),
    );
  }
}
