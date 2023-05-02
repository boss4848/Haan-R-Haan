import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';
import 'package:haan_r_haan/src/models/billDetail_models.dart';

class MemberAndExpenses extends StatefulWidget {
  final List allMember;

  const MemberAndExpenses({Key? key, required this.allMember})
      : super(key: key);

  @override
  _MemberAndExpensesState createState() => _MemberAndExpensesState();
}

class _MemberAndExpensesState extends State<MemberAndExpenses> {
  int _checkedCount = 0;

  void _handleMemberCheck(bool isChecked) {
    setState(() {
      _checkedCount += isChecked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              "Who have paid?",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: kPrimaryColor),
            ),
            const SizedBox(
              width: kDefaultPadding / 4,
            ),
            Text(
              '$_checkedCount/${widget.allMember.length} members',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: kPrimaryColor),
            ),
          ],
        ),
        const SizedBox(
          height: kDefaultPadding / 2,
        ),
        Container(
          decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [kDefaultShadow]),
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: List.generate(
                    widget.allMember.length,
                    (index) => allMemberAndBillCard(
                      allMember: widget.allMember[index],
                      onCheck: _handleMemberCheck,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: kDefaultPadding / 2,
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class allMemberAndBillCard extends StatefulWidget {
  final Map allMember;
  const allMemberAndBillCard(
      {Key? key,
      required this.allMember,
      required void Function(bool isChecked) onCheck})
      : super(key: key);

  @override
  State<allMemberAndBillCard> createState() => _allMemberAndBillCardState();
}

class _allMemberAndBillCardState extends State<allMemberAndBillCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
            Text(widget.allMember['name'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isChecked ? kPrimaryColor : const Color(0xffF47C7C)))
          ],
        ),
        Text(widget.allMember['bill'].toStringAsFixed(2) + '฿',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isChecked ? kPrimaryColor : const Color(0xffF47C7C)))
      ],
    );
  }

  Color getColor(Set<MaterialState> states) {
    if (isChecked) {
      return Colors.green;
    } else {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color.fromARGB(255, 22, 36, 49);
      }
      return const Color(0xffF47C7C);
    }
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

  Color getColor(Set<MaterialState> states) {
    if (isChecked) {
      return Colors.green;
    } else {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color.fromARGB(255, 22, 36, 49);
      }
      return const Color(0xffF47C7C);
    }
  }

  @override
  Widget build(BuildContext context) {
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
