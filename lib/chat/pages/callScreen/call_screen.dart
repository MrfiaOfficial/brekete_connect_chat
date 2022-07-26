import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/configs/agora_configs.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:brekete_connect/chat/models/call.dart';
import 'package:brekete_connect/chat/providers/user_provider.dart';
import 'package:brekete_connect/chat/services/call_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  final Call call;
  CallScreen({Key? key, required this.call}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallFirebase callFirebase = CallFirebase();
  late final RtcEngine _engine;
  late UserProvider userProvider;
  late StreamSubscription callStreamSubscription;
  List<int> _users = [];
  final _infoStrings = <String>[];
  bool muted = false, switchRender = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addPostFrameCallback();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addListeners();
    await _engine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await _engine.joinChannel(null, widget.call.channelId!, null, 0);
  }

  addPostFrameCallback() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      // userProvider = context.watch<UserProvider>(context, listen: false )
      userProvider = Provider.of<UserProvider>(context, listen: false);
      callStreamSubscription = callFirebase
          .callStream(uid: userProvider.getUser!.userId)
          .listen((DocumentSnapshot snapshot) {
        switch (snapshot.data()) {
          case null:
            // snapshot is null which means that call is hanged and documents are deleted
            Navigator.pop(context);
            break;

          default:
            break;
        }
      });
    });
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(APP_ID));
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        log('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      userJoined: (uid, elapsed) {
        log('userJoined  $uid $elapsed');
        setState(() {
          final info = 'onUserJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
        });
      },
      userInfoUpdated: (uid, userInfo) {
        log('onUpdatedUserInfo  $userInfo');
        setState(() {
          final info = 'onUpdatedUserInfo: ${userInfo.toString()}';
          _infoStrings.add(info);
        });
      },
      rejoinChannelSuccess: (string, a, b) {
        log('onRejoinChannelSuccess  $string');
        setState(() {
          final info = 'onRejoinChannelSuccess: $string';
          _infoStrings.add(info);
        });
      },
      userOffline: (uid, reason) {
        log('userOffline  $uid $reason');
        callFirebase.endCall(call: widget.call);
        _leaveChannel();
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      },
      leaveChannel: (stats) {
        log('leaveChannel ${stats.toJson()}');
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
      connectionLost: () {
        log('onConnectionLost');
        setState(() {
          final info = 'onConnectionLost';
          _infoStrings.add(info);
        });
      },
    ));
  }

  _switchRender() {
    setState(() {
      switchRender = !switchRender;
      _users = List.of(_users.reversed);
    });
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  _renderVideo() {
    return Container(
      child: Stack(
        children: [
          RtcLocalView.SurfaceView(),
          Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.of(_users.map(
                  (e) => GestureDetector(
                    onTap: this._switchRender,
                    child: Container(
                      width: 120,
                      height: 120,
                      child: RtcRemoteView.SurfaceView(
                        uid: e,
                        // channelId is just added and it's supposed not to be an empty string
                        channelId: "",
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ),
          _toolbar(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60),
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.5,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: ListView.builder(
                  reverse: true,
                  itemCount: _infoStrings.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_infoStrings.isEmpty) {
                      return Container();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF4bd8a4),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                _infoStrings[index],
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () {
              callFirebase.endCall(
                call: widget.call,
              );
              _leaveChannel();
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    callStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _renderVideo());
  }
}
