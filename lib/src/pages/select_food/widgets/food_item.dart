import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/viewmodels/user_view_model.dart';
import '../../../../constant/constant.dart';
import '../../../models/food_model.dart';
import 'member.dart';

class FoodItem extends StatefulWidget {
  final FoodModel food;
  final Function onDeleted;
  const FoodItem({
    super.key,
    required this.food,
    required this.onDeleted,
  });

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    // print('eaters: ${widget.food.eaters}');
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (isSelected) {
                  widget.onDeleted();
                  print("Delete");
                }
              },
              child: Container(
                decoration: boxShadow_2.copyWith(
                  color: const Color(0xFF3B3A5C),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                child: const Icon(
                  CupertinoIcons.trash_fill,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSelected = !isSelected;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                decoration: boxShadow_2,
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.only(right: isSelected ? 60 : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.food.foodName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        Text(
                          "${widget.food.foodPrice} Baht",
                          style: const TextStyle(
                            fontSize: 16,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(
                        widget.food.eaters.length,
                        (index) {
                          return FutureBuilder(
                              future: UserViewModel()
                                  .fetchUserByID(widget.food.eaters[index]),
                              builder: (context, snapshot) {
                                return Member(
                                  name: snapshot.data?.username ?? '',
                                );
                              });
                        },
                      ),
                    ),
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
