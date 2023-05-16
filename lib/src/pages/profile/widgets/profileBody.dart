import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/profile/widgets/paid_party.dart';
import 'package:haan_r_haan/src/pages/profile/widgets/user_info.dart';
import 'package:provider/provider.dart';

import '../../../services/auth_service.dart';
import '../../../viewmodels/auth_view_model.dart';
import '../../../viewmodels/user_view_model.dart';

// ignore: camel_case_types
class profileBody extends StatelessWidget {
  const profileBody({super.key});

  // signOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(children: const [
            SizedBox(
                width: double.infinity,
                child: Image(
                  image: AssetImage('assets/images/Banner.gif'),
                  fit: BoxFit.cover,
                )),
            // Container(
            //   margin: const EdgeInsets.only(left: 33, top: 65),
            //   width: 130,
            //   height: 130,
            //   decoration: const BoxDecoration(
            //     shape: BoxShape.circle,
            //     image: DecorationImage(
            //       fit: BoxFit.cover,
            //       image: AssetImage('assets/images/profile.jpg'),
            //     ),
            //   ),
            // )
          ]),
        ),
        const UserInfoWidget(),
        const PaidPartyWidget(),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: const BorderSide(color: kPrimaryColor),
                      ),
                      onPressed: () async {
                        await AuthService().changePassword("").then((value) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            title: "Please check your email",
                            confirmBtnText: "Ok",
                          );
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding / 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Change Password'),
                          ],
                        ),
                      ))),
              const SizedBox(
                height: kDefaultPadding / 2,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadowColor: Colors.black38),
                    onPressed: () {
                      Provider.of<UserViewModel>(
                        context,
                        listen: false,
                      ).clearUserData();
                      Provider.of<AuthViewModel>(
                        context,
                        listen: false,
                      ).signOut();
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                      child: Text("Sign out"),
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }
}
