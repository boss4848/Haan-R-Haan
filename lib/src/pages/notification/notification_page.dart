import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/pages/notification/widget/noti_item.dart';
import 'package:haan_r_haan/src/viewmodels/noti_view_model.dart';
import 'package:haan_r_haan/src/widgets/loading_dialog.dart';
import '../../models/noti_model.dart';

class NotificationPage extends StatelessWidget {
  final List<NotiModel> notiList;
  const NotificationPage({super.key, required this.notiList});

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
            children: [
              const SizedBox(height: 160),
              if (notiList.length > 5)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        loadingDialog(context);
                        await NotiViewModel().clearAllNoti();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Clear all",
                        style: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 15),
              for (var noti in notiList)
                NotiItem(
                  title: noti.title,
                  body: noti.body,
                  dateCreated: noti.createdAt,
                  notiId: noti.notiId,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildBanner(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: kDefaultBG,
      ),
      height: 140,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Row(
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
              const Text(
                "Notifications",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
