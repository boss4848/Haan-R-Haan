import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../../constant/constant.dart';
// import '../viewmodels/party_view_model.dart';

class ShadowContainer extends StatelessWidget {
  final List<Widget> list;
  // final void Function()? handleFunction;
  final int partiesCount;
  // final bool hasMore;

  const ShadowContainer({
    // this.handleFunction,
    required this.list,
    super.key,
    required this.partiesCount,
    // required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 10,
          ),
          decoration: boxShadow_1,
          child: Column(children: list
              // if (hasMore)
              //   GestureDetector(
              //     onTap: () => handleFunction!(),
              //     child: const SizedBox(
              //       width: double.infinity,
              //       child: Icon(
              //         Icons.more_horiz,
              //         color: kPrimaryColor,
              //       ),
              //     ),
              //   ),

              ),
        ),
        const SizedBox(height: 10),
        // if (hasMore)
        //   GestureDetector(
        //     onTap: () => handleFunction!(),
        //     child: Container(
        //       padding: const EdgeInsets.only(
        //         right: 20,
        //         top: 10,
        //       ),
        //       alignment: Alignment.centerRight,
        //       child: const Text(
        //         "Show more",
        //         style: TextStyle(
        //           color: kPrimaryColor,
        //           fontSize: 15,
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
