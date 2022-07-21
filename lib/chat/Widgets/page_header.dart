import 'package:brekete_connect/chat/enum/user_state.dart';
import 'package:brekete_connect/chat/providers/ConnectivityChangeNotifier.dart';
import 'package:brekete_connect/chat/utility/utilityStatus.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomPageHeader extends StatelessWidget {
  final String? title;
  final double? textSize;
  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? suffixWidget;
  final int? subTitle;
  CustomPageHeader(
      {this.title,
      this.textSize,
      this.fontWeight,
      this.backgroundColor,
      this.textColor,
      this.suffixWidget,
      this.subTitle});

  @override
  Widget build(BuildContext context) {
    String getStatus(int? status) {
      switch (UtilityStatus.numToState(status!)) {
        case UserState.Offline:
          return 'Offline';
        case UserState.Online:
          return 'Online';
        default:
          return '';
      }
    }

    return Container(
      child: Stack(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  child: suffixWidget,
                ),
                Text(
                  title ?? "Header",
                  maxLines: 10,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.normal,
                          color: textColor ?? Theme.of(context).accentColor,
                          letterSpacing: 0)),
                ),
              ],
            ),
          ),
          //*******for the connection */
          if (context.watch<ConnectivityChangeNotifier>().connectivity ==
              ConnectivityResult.none)
            Padding(
              padding: const EdgeInsets.only(
                left: 50.0,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  context.watch<ConnectivityChangeNotifier>().pageText,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.normal,
                          color: Colors.red,
                          letterSpacing: 0)),
                ),
              ),
            ),
          //
          subTitle != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 60, top: 50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      getStatus(subTitle!),
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.normal,
                              color: Theme.of(context).accentColor,
                              letterSpacing: 0)),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
