import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../size_config.dart';

class DialButton extends StatelessWidget {
  const DialButton({
    Key? key,
    required this.iconSrc,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String? iconSrc, text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(120),
      // ignore: deprecated_member_use
      child: FlatButton(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(20),
        ),
        onPressed: press,
        child: Column(
          children: [
            SvgPicture.asset(
              iconSrc!,
              color: Theme.of(context).accentColor,
              height: 36,
            ),
            VerticalSpacing(of: 5),
            Text(
              text!,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }
}
