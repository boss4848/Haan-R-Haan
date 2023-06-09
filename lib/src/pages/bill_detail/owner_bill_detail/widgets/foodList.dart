import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/bill_detail/owner_bill_detail/widgets/promptPay.dart';

import '../../../../../../constant/constant.dart';
import '../../../../models/billDetail_models.dart';
import 'MemberAndBill.dart';
import 'foodListCard.dart';

class FoodList extends StatefulWidget {
  final Party party;
  const FoodList({
    Key? key,
    required this.party,
  }) : super(key: key);

  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final foodListLength = widget.party.foodName.length;
    final foodListToShow = showAll ? foodListLength : 3;

    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Food List',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: kPrimaryColor)),
              const SizedBox(
                width: kDefaultPadding / 4,
              ),
              Text(
                '$foodListLength items',
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
            child: Column(
              children: List.generate(
                foodListToShow,
                (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: FoodListCard(
                        foodList: widget.party.foodName[index],
                        foodPrice: widget.party.foodPrice[index],
                        allMember: widget.party.allMember)),
              ),
            ),
          ),
          if (foodListLength > 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!showAll)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAll = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Show more',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (showAll)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAll = false;
                      });
                    },
                    child: Text(
                      'Show less',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          MemberAndExpenses(allMember: widget.party.allMember),
          const SizedBox(
            height: kDefaultPadding,
          ),
          const PromptpatPayment()
        ],
      ),
    );
  }
}
