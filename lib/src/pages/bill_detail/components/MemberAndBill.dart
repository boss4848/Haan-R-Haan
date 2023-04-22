import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/models/billDetail_models.dart';

class MemberAndExpenses extends StatelessWidget {
  final List allMember;
  const MemberAndExpenses({Key? key, required this.allMember})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Who have paid?",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'SFTHONBURI',
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: kDefaultPadding / 2,
        ),
        SizedBox(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: List.generate(allMember.length,
                  (index) => allMemberAndBillCard(allMember: allMember[index])),
            ),
          ),
        )
      ],
    );
  }
}

// ignore: camel_case_types
class allMemberAndBillCard extends StatelessWidget {
  final Map allMember;
  const allMemberAndBillCard({Key? key, required this.allMember})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const MemberCheckbox(),
            Text(
              allMember['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'SFTHONBURI',
              ),
            )
          ],
        ),
        Text(
          allMember['bill'].toStringAsFixed(2) + '฿',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'SFTHONBURI',
          ),
        )
      ],
    );
  }
}

// MemberCheckbox

class MemberCheckbox extends StatefulWidget {
  const MemberCheckbox({super.key});

  @override
  State<MemberCheckbox> createState() => _MemberCheckboxState();
}

class _MemberCheckboxState extends State<MemberCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return const Color(0xFF96A362);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
      ],
    );
  }
}
