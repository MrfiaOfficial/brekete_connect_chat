
import 'package:flutter/material.dart';
import 'package:group_chat_app/shop/constants/app_color.dart';

class AppTextStyles {
  static TextStyle underlineText = const TextStyle(
    fontSize: 15,
    color: Color(0xff40536E),
    decoration: TextDecoration.underline,
  );
  static TextStyle headingText = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black);
  static TextStyle mediumText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static TextStyle simpleText = TextStyle(
    fontSize: 14,
  );
  static TextStyle fadeText =
      TextStyle(fontSize: 13, color: AppColor.fadeColor);

  static TextStyle dialogHeadingText =
      const TextStyle(fontSize: 13, fontWeight: FontWeight.bold);

  static TextStyle smallText = TextStyle(
    fontSize: 12,
  );
  static TextStyle textWithShadow = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        offset: Offset(0.0, 0.0),
        blurRadius: 50,
      )
    ],
  );
}
