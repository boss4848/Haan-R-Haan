import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/models/billDetail_models.dart';
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';

import '../../../../../constant/constant.dart';

class PromptpayPaymentForMember extends StatelessWidget {
  const PromptpayPaymentForMember({super.key});

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
              child: MemberPromptPayQRCOde(
                party: parties[1],
              )),
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
                      children: const [
                        Icon(Icons.save_as_rounded),
                        Text(' Save Image'),
                      ],
                    ),
                  ))),
        )
      ],
    );
  }
}

class MemberPromptPayQRCOde extends StatefulWidget {
  final Party party;
  const MemberPromptPayQRCOde({
    super.key,
    required this.party,
  });

  @override
  State<MemberPromptPayQRCOde> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MemberPromptPayQRCOde> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [kDefaultShadow]),
      child: QRCodeGenerate(
        promptPayId: widget.party.ownerPhone,
        amount: 113.30,
        width: 400,
        height: 400,
      ),
    );
  }
}
