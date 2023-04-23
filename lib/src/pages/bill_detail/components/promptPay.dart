import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/models/billDetail_models.dart';
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';

import '../../../../constant/constant.dart';

class PromptpatPayment extends StatelessWidget {
  const PromptpatPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Promptpay QR Code",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'SFTHONBURI',
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // ignore: prefer_const_constructors
            decoration: BoxDecoration(boxShadow: const [kDefaultShadow]),
            child: PromptPayQRCOde(
              party: parties[0],
            ),
          ),
        )
      ],
    );
  }
}

class PromptPayQRCOde extends StatefulWidget {
  final Party party;
  const PromptPayQRCOde({
    super.key,
    required this.party,
  });

  @override
  State<PromptPayQRCOde> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PromptPayQRCOde> {
  @override
  Widget build(BuildContext context) {
    return QRCodeGenerate(
      promptPayId: widget.party.ownerPhone,
      amount: 00.00,
      width: 400,
      height: 400,
    );
  }
}
