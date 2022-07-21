import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/database/repository/log_repository.dart';
import 'package:brekete_connect/chat/models/call.dart';
import 'package:brekete_connect/chat/models/log.dart';
import 'package:brekete_connect/chat/pages/dialScreen/dial_screen.dart';
import 'package:brekete_connect/chat/pages/tabs/chats/widget/cached_image.dart';
import 'package:brekete_connect/chat/services/call_firebase.dart';
import 'package:brekete_connect/chat/utility/permissions.dart';
import 'package:flutter/material.dart';

import '../call_screen.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({Key? key, required this.call});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallFirebase callMethods = CallFirebase();
  bool isCallMissed = true;

  addToLocalStorage({required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now(),
      callStatus: callStatus,
    );

    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            widget.call.callerStatus == CALL_STATUS_VIDEO
                ? Text(
                    "VdieoCall...",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                : Container(),
            SizedBox(height: 50),
            CachedImage(
              widget.call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(height: 15),
            Text(
              widget.call.callerName.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            widget.call.callerStatus == CALL_STATUS_VIDEO
                ? Icon(
                    Icons.video_call,
                    size: 30,
                    color: Color(0xFF4bd8a4),
                  )
                : Icon(
                    Icons.audiotrack,
                    size: 30,
                    color: Color(0xFF4bd8a4),
                  ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      if (widget.call.callerStatus == CALL_STATUS_VIDEO) {
                        await Permissions
                                .cameraAndMicrophonePermissionsGranted()
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CallScreen(call: widget.call),
                                ),
                              )
                            // ignore: unnecessary_statements
                            : {};
                      } else {
                        await Permissions.microphonePermissionsGranted()
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DialScreen(call: widget.call),
                                ),
                              )
                            // ignore: unnecessary_statements
                            : {};
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
