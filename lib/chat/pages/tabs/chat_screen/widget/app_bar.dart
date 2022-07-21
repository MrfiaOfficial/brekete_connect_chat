import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/models/user_model.dart';
import 'package:brekete_connect/chat/pages/contacts_screen/contact_details.dart';
import 'package:brekete_connect/chat/utility/call_utilities.dart';
import 'package:brekete_connect/chat/utility/permissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget {
  final UserData? peer;
  final String? groupId;
  // final UserData? receiver;
  final UserData? sender;

  MyAppBar({Key? key, this.peer, this.groupId, this.sender}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _animation;

  late Timer _timer;
  bool collapsed = false;
  var stream;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    // steram of peer details
    stream = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(widget.peer!.userId)
        .snapshots();
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController);
    _timer = Timer(Duration(seconds: 3), () {
      collapse();
    });
  }

  @override
  void dispose() {
    _animationController.removeListener(() {});
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void collapse() {
    _animationController.forward();
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      if (this.mounted) setState(() => collapsed = true);
    });
  }

  void goToContactDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ContactDetails(contact: widget.peer, groupId: widget.groupId),
      ),
    );
  }

  bool tapped = false;
  void toggle() {
    setState(() {
      tapped = !tapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      leading: CBackButton(),
      title: CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: goToContactDetails,
        child: Row(
          children: [
            Avatar(imageUrl: widget.peer!.img!, radius: kToolbarHeight / 2 - 5),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.peer!.username!.split(' ')[0],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).accentColor,
                    )),
                if (collapsed)
                  StreamBuilder(
                      stream: stream,
                      builder: (ctx, snapshot) {
                        if (!snapshot.hasData)
                          return Container(width: 0, height: 0);
                        else {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: widget.peer!.status! == 1 ? 13 : 0,
                            child: Text(
                              'Online',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.7),
                              ),
                            ),
                          );
                        }
                      }),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  height: collapsed ? 0 : 13,
                  child: FadeTransition(
                    opacity: _animation,
                    child: Text(
                      'tap for more info',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).accentColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
          child: Wrap(
            children: [
              CupertinoButton(
                onPressed: () => makeVoiceCall(),
                padding: const EdgeInsets.all(0),
                child: Icon(Icons.call, color: Theme.of(context).accentColor),
              ),
              CupertinoButton(
                onPressed: () => makeVideoCall(),
                padding: const EdgeInsets.all(0),
                child: Icon(Icons.video_call,
                    color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void makeVoiceCall() async {
    await Permissions.microphonePermissionsGranted()
        ? CallUtils.dialAudio(
            from: widget.sender,
            to: widget.peer,
            context: context,
          )
        // ignore: unnecessary_statements
        : {};
  }

  void makeVideoCall() async {
    await Permissions.cameraAndMicrophonePermissionsGranted()
        ? CallUtils.dialVideo(
            from: widget.sender,
            to: widget.peer,
            context: context,
          )
        // ignore: unnecessary_statements
        : {};
  }
}

class CBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos
        ? CupertinoButton(
            padding: const EdgeInsets.all(0),
            child:
                Icon(CupertinoIcons.back, color: Theme.of(context).accentColor),
            onPressed: () => Navigator.of(context).pop(),
          )
        : BackButton(
            color: Theme.of(context).accentColor,
          );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({
    required this.imageUrl,
    this.radius = 15,
    Key? key,
  }) : super(key: key);

  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).accentColor,
      // ignore: unnecessary_null_comparison
      backgroundImage: imageUrl == null || imageUrl == ''
          ? null
          : CachedNetworkImageProvider(imageUrl),
      // ignore: unnecessary_null_comparison
      child: imageUrl == null || imageUrl == ''
          ? Image.asset(
              'assets/images/account.png',
              fit: BoxFit.cover,
            )
          : null,
      radius: radius,
    );
  }
}
