import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brekete_connect/shop/constants/app_color.dart';

class CustomButton {
  static Widget myButton(
      String text, Function() onTap, Color color, double width,
      {IconData icon,
      Color textColor,
      Color sideborderColor,
      double height,
      TextStyle textStyle}) {
    return MaterialButton(
      onPressed: onTap,
      color: color,
      child: SizedBox(
        width: width,
        height: height ?? 45,
        child: Center(
          child: FittedBox(
            child: Text(
              text,
              style: textStyle ??
                  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? Colors.white,
                  ),
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: sideborderColor ?? AppColor.primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
    );
  }

  static Widget cicularIndicatorButton(
      Widget text, Function() onTap, Color color, double width,
      {IconData icon,
      Color textColor,
      Color sideborderColor,
      TextStyle textStyle}) {
    return MaterialButton(
      onPressed: onTap,
      color: color,
      child: SizedBox(
        width: width,
        child: Center(
          child: FittedBox(child: text),
        ),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: sideborderColor ?? AppColor.primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
    );
  }

  static Widget myButton2(
      String text, Function() onTap, Color color, double width,
      {IconData icon,
      Color iconColor,
      Color textColor,
      Color sideborderColor,
      TextStyle textStyle}) {
    return MaterialButton(
      padding: EdgeInsets.all(4),
      minWidth: width,
      onPressed: onTap,
      color: color,
      child: SizedBox(
        width: width,
        height: 30,
        child: FittedBox(
          child: Row(
            children: [
              icon == null
                  ? const SizedBox.shrink()
                  : Icon(
                      icon,
                      color: iconColor,
                    ),
              const SizedBox(
                width: 5,
              ),
              Center(
                child: Text(
                  text,
                  style: textStyle ??
                      TextStyle(
                        fontSize: 18,
                        color: textColor ?? Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: sideborderColor ?? AppColor.primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
    );
  }
}
