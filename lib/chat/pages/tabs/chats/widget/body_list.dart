import 'package:flutter/material.dart';

class BodyList extends StatelessWidget {
  final Widget child;
  BodyList({
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: child,
        //
      ),
    );
  }
}
