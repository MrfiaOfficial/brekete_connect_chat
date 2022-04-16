import 'package:flutter/material.dart';

class AppNavigator {
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static Future<void> pushSync(BuildContext context, Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void pushRootTrue(BuildContext context, Widget page) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (context) => page));
  }

  static void replace(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void replaceWithRootTrue(BuildContext context, Widget page) {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void makeFirst(BuildContext context, Widget page) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  // static void makeFirst2(BuildContext context, Widget page) {
  //   Navigator.of(context).popUntil((predicate) => predicate.isFirst);
  //   Navigator.of(context, rootNavigator: true).pushReplacement(
  //     new MaterialPageRoute(builder: (context) => page),
  //   );
  // }

  static void makeFirstRootTrue(BuildContext context, Widget page) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void dismissAlert(context) {
    Navigator.of(context).pop();
  }
}
