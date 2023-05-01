import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/constant/constant.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../../models/billDetail_models.dart';

// ignore: camel_case_types
class billDetailBar extends StatelessWidget {
  const billDetailBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [kDefaultShadow]),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE9E9E9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(kDefaultPadding / 2),
                  child: Text(
                    'Description',
                    style: TextStyle(
                        fontFamily: 'SFTHONBURI',
                        color: kPrimaryColor,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RemainingUnpaid(
                      party: parties[0],
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    TotalAmount(party: parties[0]),
                    Container(
                      width: 1,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    TotalLent(
                      party: parties[0],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RemainingUnpaid extends StatefulWidget {
  final Party party;
  const RemainingUnpaid({super.key, required this.party});

  @override
  State<RemainingUnpaid> createState() => _RemainingUnpaidState();
}

class _RemainingUnpaidState extends State<RemainingUnpaid> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              widget.party.allMember.length.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: kDefaultPadding / 4,
            ),
            Text('Members',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: kPrimaryColor))
          ],
        ),
        Text(
          'UNPAID',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
        )
      ],
    );
  }
}

class TotalAmount extends StatefulWidget {
  final Party party;
  const TotalAmount({super.key, required this.party});

  @override
  State<TotalAmount> createState() => _TotalAmountState();
}

class _TotalAmountState extends State<TotalAmount> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Icon(
              CupertinoIcons.money_dollar_circle_fill,
              color: greenPastelColor,
            ),
            SvgPicture.asset(
              'assets/icons/money_layer.svg',
              // ignore: deprecated_member_use
              color: greenPastelColor,
            ),
            const SizedBox(
              width: kDefaultPadding / 10,
            ),
            Text(
              '${widget.party.totalPrice.toStringAsFixed(0)}฿',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )
          ],
        ),
        Text(
          'TOTAL AMOUNT',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
        )
      ],
    );
  }
}

class TotalLent extends StatefulWidget {
  final Party party;
  const TotalLent({super.key, required this.party});

  @override
  State<TotalLent> createState() => _TotalLentState();
}

class _TotalLentState extends State<TotalLent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Icon(
              CupertinoIcons.money_dollar_circle_fill,
              color: redPastelColor,
            ),
            const SizedBox(
              width: kDefaultPadding / 10,
            ),
            Text(
              '-${widget.party.totalPrice.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: redPastelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )
          ],
        ),
        Text(
          'TOTAL LENT',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
        )
      ],
    );
  }
}
