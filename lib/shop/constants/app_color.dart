import 'package:flutter/material.dart';

class AppColor {
  static MaterialColor primarySwatch = MaterialColor(
    0xff091166, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: const Color(0xff091166).withOpacity(0.1), //10%
      100: const Color(0xff091166).withOpacity(0.2), //20%
      200: const Color(0xff091166).withOpacity(0.3), //30%
      300: const Color(0xff091166).withOpacity(0.4), //40%
      400: const Color(0xff091166).withOpacity(0.5), //50%
      500: const Color(0xff091166).withOpacity(0.6), //60%
      600: const Color(0xff091166).withOpacity(0.7), //70%
      700: const Color(0xff091166).withOpacity(0.8), //80%
      800: const Color(0xff091166).withOpacity(0.9), //90%
      900: const Color(0xff091166).withOpacity(1.0), //100%
    },
  );

  static Color fadeColor = const Color(0xff8F9BB3);
  static Color errorColor = const Color(0xffF94231);
  static Color yellowColor = const Color(0xffFFDE33);
  static Color dimBorderColor = const Color(0xffE7ECF0);
  static Color primaryColor = const Color(0xff091166);
  static Color navBarGrey = const Color(0xffC5CEE0);
  static Color splashColor = const Color(0xffA7FFCA);
  static Color navBarWhite = const Color(0xffFFFFFF);
  static Color transparent = Colors.transparent;
  static Color headingTextColor = const Color(0xff40536E);
  static Color whiteColor = Colors.white;
  static Color boxBlue = const Color(0xffC5CEE0);
  static Color audioEffectButton = const Color(0xffF5F4FF);
  static Color blackColor = Colors.black;
  static Color practiceButton = const Color(0xff6249E3);
  static Color greyColor = Colors.grey;
  static Color testDoneBackground = const Color(0xffD5FFE6);
  static Color testDone = const Color(0xff40536E);
  static Color leftContainer = const Color(0xffF5F4FF);
  static Color rightContainer = const Color(0xffD5FFE6);
  static Color onlineGreen = const Color(0xff1EC100);
  static Color containerBackground = const Color(0xffF2F4F6);
  static Color audioGradient = const Color(0xff9D6AFF);
  static Color rightBarColor = const Color(0xff5DFFE6);
}
