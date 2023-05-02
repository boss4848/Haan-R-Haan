import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/models/billDetail_models.dart';
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';

import '../../../../../constant/constant.dart';

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
              color: kPrimaryColor,
              fontSize: 26,
              fontFamily: 'SFTHONBURI',
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            child: PromptPayQRCOde(
              party: parties[0],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: Container(
              alignment: Alignment.center,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: kPrimaryColor),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_as_rounded),
                        Text('Save Image'),
                      ],
                    ),
                  ))),
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
    return Container(
      decoration: const BoxDecoration(boxShadow: [kDefaultShadow]),
      child: QRCodeGenerate(
        promptPayId: widget.party.ownerPhone,
        amount: 00.00,
        width: 400,
        height: 400,
      ),
    );
  }
}
