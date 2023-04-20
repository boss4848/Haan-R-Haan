import 'package:flutter/material.dart';
import '../../../../constant/constant.dart';
import '../../../models/mockup_data.dart';
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

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
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
                margin: const EdgeInsets.only(
                    top: kDefaultPadding / 4, bottom: kDefaultPadding / 2),
                child: Column(
                  children: List.generate(
                    foodListToShow,
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: foodListCard(
                        foodList: widget.party.foodName[index],
                        foodPrice: widget.party.foodPrice[index],
                      ),
                    ),
                  ),
                ),
              ),
              if (foodListLength > 3)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          children: [
                            Text(
                              '...',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Show all lists',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
                        child: Text(
                          'Show less',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
