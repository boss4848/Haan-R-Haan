import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:flutter/services.dart';

import '../../main/main_page.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  // String _username = "Yo";
  // String _email = "yo@gmail.com";
  // String _phoneNo = "0956786848";
  String _username = userData["username"];
  final String _email = userData["email"];
  String _phoneNo = userData["phoneNumber"];

  void _editUserInfo() async {
    final updatedUserInfo = await showModalBottomSheet<Map<String, String>>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        final usernameController = TextEditingController(text: _username);
        final phoneNoController = TextEditingController(text: _phoneNo);

        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 8.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0))),
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 7,
                      width: 100,
                      decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    SizedBox(
                      height: kDefaultPadding / 2,
                    ),
                    Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/editinfo.svg',
                          // ignore: deprecated_member_use
                          color: kPrimaryColor,
                          width: 40,
                        ),
                        SizedBox(
                          height: kDefaultPadding / 4,
                        ),
                        Text(
                          "Edit Account",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: kPrimaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    TextField(
                      controller: usernameController,
                      //RegExp(r'^[a-zA-Z0-9._]+$')
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9._]'))
                      ],
                      decoration: const InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(
                          Icons.person_2_rounded,
                          color: kPrimaryColor,
                        ),
                        hintText: 'Your Username',
                        fillColor: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      '*Username can only contain letters, numbers, ".", and "_"*',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    TextField(
                      controller: phoneNoController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: Icon(
                          Icons.phone_android_rounded,
                          color: kPrimaryColor,
                        ),
                        hintText: 'Your Phone No.',
                        fillColor: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      '*Phone number can only contain digits (0-9)',
                      style: TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: kDefaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, null);
                          },
                          child: Text(
                            "Cancel",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final newUserInfo = {
                              "username": usernameController.text,
                              "phoneNo": phoneNoController.text,
                            };
                            Navigator.pop(context, newUserInfo);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                          ),
                          child: Text(
                            "Save",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (updatedUserInfo != null) {
      setState(() {
        _username = updatedUserInfo["username"] ?? "invalid username";
        _phoneNo = updatedUserInfo["phoneNo"] ?? "invalid phone no.";
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
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('email',
                    isEqualTo: FirebaseAuth.instance.currentUser!.email)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: const [
                      SizedBox(
                          child: Image(
                        image: AssetImage('assets/images/logoloading.gif'),
                        width: 100,
                      )),
                      Text("Loading..."),
                    ],
                  ),
                );
              }

              return Column(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
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
              );
            }),
      ),
    );
  }
}
