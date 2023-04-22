import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/pages/bill_detail/components/MemberAndBill.dart';
import 'package:haan_r_haan/src/pages/bill_detail/components/promptPay.dart';
import '../../../../constant/constant.dart';
import '../../../models/billDetail_models.dart';
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
          const Text(
            'Food List',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'SFTHONBURI',
                fontWeight: FontWeight.w600),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: Column(
              children: List.generate(
                foodListToShow,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: foodListCard(
                    foodList: widget.party.foodName[index],
                    foodPrice: widget.party.foodPrice[index],
                    allMember: widget.party.allMember,
                  ),
                ),
              ),
            ),
          ),
          if (foodListLength > 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!showAll)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAll = true;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '...',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SFTHONBURI',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Show more',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'SFTHONBURI',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                if (showAll)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAll = false;
                      });
                    },
                    child: const Text(
                      'Show less',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SFTHONBURI',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
              ],
            ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              'Total : ' + '${widget.party.totalPrice.toStringAsFixed(2)}฿',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          MemberAndExpenses(allMember: widget.party.allMember),
          SizedBox(
            height: kDefaultPadding,
          ),
          PromptpatPayment()
        ],
      ),
    );
  }
}
