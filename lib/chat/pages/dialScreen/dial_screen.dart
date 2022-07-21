import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/configs/agora_configs.dart';
import 'package:brekete_connect/chat/models/call.dart';
import 'package:brekete_connect/chat/pages/components/dial_user_pic.dart';
import 'package:brekete_connect/chat/pages/components/rounded_button.dart';
import 'package:brekete_connect/chat/providers/user_provider.dart';
import 'package:brekete_connect/chat/services/call_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';
import 'components/dial_button.dart';

class DialScreen extends StatefulWidget {
  const DialScreen({
    Key? key,
    required this.call,
  }) : super(key: key);
  final Call call;

  @override
  _DialScreenState createState() => _DialScreenState();
}

class _DialScreenState extends State<DialScreen>
    with SingleTickerProviderStateMixin {
  late final RtcEngine _engine;
  final _infoStrings = <String>[];
  final CallFirebase callFirebase = CallFirebase();
  late AnimationController _animationController;
  int? countLevel = 180;
  late UserProvider userProvider;
  late StreamSubscription callStreamSubscription;

  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;

  @override
  void initState() {
    super.initState();
    initializeAgora();
    addPostFrameCallback();
  }

  startCounting() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: countLevel!));
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    // destroy sdk
    _animationController.dispose();
    _engine.leaveChannel();
    _engine.destroy();
    _infoStrings.clear();
    callStreamSubscription.cancel();
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
    // await _engine.setParameters(
    //     '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await _engine
        .joinChannel(null, widget.call.channelId!, null, 0)
        .catchError((onError) {
      // print('error ${onError.toString()}');
    });
    // await _engine.joinChannel(null, widget.call.channelId!, null, 0);
  }

  addPostFrameCallback() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
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

  _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(APP_ID));
    this._addListeners();
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        log('joinChannelSuccess $channel $uid $elapsed');
        startCounting();
        setState(() {
          isJoined = true;
        });
      },
      leaveChannel: (stats) async {
        log('leaveChannel ${stats.toJson()}');
        callFirebase.endCall(call: widget.call);
        setState(() {
          final info = 'leaveChannel:  ${stats.toJson()}';
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
        });
      },
    ));
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  _switchMicrophone() {
    _engine.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {
      log('enableLocalAudio $err');
    });
  }

  _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {
      log('setEnableSpeakerphone $err');
    });
  }

  _switchEffect() async {
    if (playEffect) {
      _engine.stopEffect(1).then((value) {
        setState(() {
          playEffect = false;
        });
      }).catchError((err) {
        log('stopEffect $err');
      });
    } else {
      _engine
          .playEffect(
              1,
              await (_engine.getAssetAbsolutePath("assets/Sound_Horizon.mp3")
                  as FutureOr<String>),
              -1,
              1,
              1,
              100,
              true)
          .then((value) {
        setState(() {
          playEffect = true;
        });
      }).catchError((err) {
        log('playEffect $err');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                widget.call.receiverName!,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Theme.of(context).accentColor),
              ),
              isJoined
                  ? CountDown(
                      animation: StepTween(begin: 0, end: countLevel!)
                          .animate(_animationController))
                  : Text(
                      "Calling…",
                      style: TextStyle(
                          color:
                              Theme.of(context).accentColor.withOpacity(0.3)),
                    ),
              VerticalSpacing(),
              DialUserPic(image: widget.call.receiverPic!),
              Spacer(),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  DialButton(
                    iconSrc: "assets/icons/Icon Mic.svg",
                    text: enableSpeakerphone ? 'Speakerphone' : 'Earpiece',
                    press: this._switchSpeakerphone,
                  ),
                  DialButton(
                    iconSrc: "assets/icons/Icon Volume.svg",
                    text: "Microphone ${openMicrophone ? 'on' : 'off'}",
                    press: this._switchMicrophone,
                  ),
                  DialButton(
                    iconSrc: "assets/icons/Icon Video.svg",
                    text: "Video",
                    press: () {},
                  ),
                  DialButton(
                    iconSrc: "assets/icons/Icon Message.svg",
                    text: "Message",
                    press: () {},
                  ),
                  DialButton(
                    iconSrc: "assets/icons/Icon User.svg",
                    text: "Add contact",
                    press: () {},
                  ),
                  DialButton(
                    iconSrc: "assets/icons/Icon Voicemail.svg",
                    text: "${playEffect ? 'Stop' : 'Play'} effect",
                    press: this._switchEffect,
                  ),
                ],
              ),
              VerticalSpacing(),
              RoundedButton(
                iconSrc: "assets/icons/call_end.svg",
                press: () {
                  callFirebase.endCall(
                    call: widget.call,
                  );
                  _leaveChannel();
                },
                color: Color(0xFFFF1E46),
                iconColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CountDown extends AnimatedWidget {
  CountDown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int?> animation;

  @override
  Widget build(BuildContext context) {
    Duration timerCount = Duration(seconds: animation.value!);
    String? timerText =
        '${timerCount.inMinutes.remainder(60).toString()} : ${timerCount.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text(
      "$timerText",
      style: TextStyle(color: Theme.of(context).accentColor),
    );
  }
}
