import 'dart:math';

import 'package:connect_chat/constants/strings.dart';
import 'package:connect_chat/database/repository/log_repository.dart';
import 'package:connect_chat/models/call.dart';
import 'package:connect_chat/models/log.dart';
import 'package:connect_chat/models/user_model.dart';
import 'package:connect_chat/pages/callScreen/call_screen.dart';
import 'package:connect_chat/pages/dialScreen/dial_screen.dart';
import 'package:connect_chat/services/call_firebase.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CallUtils {
  static final CallFirebase callFirebase = CallFirebase();

  static dialVideo({UserData? from, UserData? to, context}) async {
    Call call = Call(
      callerId: from!.userId,
      callerName: from.username,
      callerPic: from.img,
      receiverId: to!.userId,
      receiverName: to.username,
      receiverPic: to.img,
      callerStatus: CALL_STATUS_VIDEO,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.username,
      callerPic: from.img,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.username,
      receiverPic: to.img,
      status: CALL_STATUS_VIDEO,
      timestamp: DateTime.now(),
    );

    bool callMade = await callFirebase.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      // enter log
      LogRepository.addLogs(log);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: CallScreen(
                call: call,
              )));
    }
  }

  static dialAudio({UserData? from, UserData? to, context}) async {
    Call call = Call(
      callerId: from!.userId,
      callerName: from.username,
      callerPic: from.img,
      receiverId: to!.userId,
      receiverName: to.username,
      receiverPic: to.img,
      callerStatus: CALL_STATUS_AUDIO,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.username,
      callerPic: from.img,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.username,
      receiverPic: to.img,
      status: CALL_STATUS_AUDIO,
      timestamp: DateTime.now(),
    );

    bool callMade = await callFirebase.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      // enter log
      LogRepository.addLogs(log);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: DialScreen(
                call: call,
              )));
    }
  }
}
