import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonName;
  final bool? isOutlined;

  const Button(this.onPressed, this.buttonName,
      {super.key, this.isOutlined = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          elevation: MaterialStateProperty.all(10),
          //outlined
          side: isOutlined!
              ? MaterialStateProperty.all(
                  const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                )
              : null,
          backgroundColor: MaterialStateProperty.all(
            isOutlined! ? Colors.transparent : Colors.blue,
          ),
          shadowColor: MaterialStateProperty.all(
            isOutlined! ? Colors.transparent : Colors.blue,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: TextStyle(
            color: isOutlined! ? Colors.blue : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
