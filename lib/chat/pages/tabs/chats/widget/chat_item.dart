import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/models/user_model.dart';
import 'package:brekete_connect/chat/services/auth_firebase.dart';
import 'package:brekete_connect/chat/utility/call_utilities.dart';
import 'package:brekete_connect/chat/utility/permissions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'online_dot_indicator.dart';

class ChatItemList extends StatelessWidget {
  final AuthFirebase _authFirebase = AuthFirebase();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);

  final String? userName;
  final Widget? subtitle;
  final Widget? time;
  final String? imageUrl;
  final String? conversationId;
  final Function? onpressed;
  final UserData? receiver;

  final bool delete;
  ChatItemList({
    Key? key,
    required this.receiver,
    required this.userName,
    required this.subtitle,
    required this.imageUrl,
    this.delete = false,
    required this.onpressed,
    this.time,
    required this.conversationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onpressed!(context, receiver),
      child: Slidable(
        startActionPane: ActionPane(
          key: const ValueKey(0),
          dismissible: DismissiblePane(onDismissed: () {}),
          motion: DrawerMotion(),
          children: [
            Container(
              padding: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: SlidableAction(
                //borderRadius: BorderRadius.all(Radius.circular(50)),
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.phone,
                //label: 'Phone',
                onPressed: (value) async {
                  UserData? userData = await _authFirebase.getUserDetails();
                  UserData? sender = UserData(
                    userId: userData.userId,
                    username: userData.username,
                    img: userData.img,
                  );
                  await Permissions.cameraAndMicrophonePermissionsGranted()
                      ? CallUtils.dialAudio(
                          from: sender,
                          to: receiver,
                          context: context,
                        )
                      // ignore: unnecessary_statements
                      : {};
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: SlidableAction(
                //borderRadius: BorderRadius.all(Radius.circular(50)),
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.videocam,
                //label: 'Phone',
                onPressed: (value) async {
                  UserData? userData = await _authFirebase.getUserDetails();
                  UserData? sender = UserData(
                    userId: userData.userId,
                    username: userData.username,
                    img: userData.img,
                  );
                  await Permissions.cameraAndMicrophonePermissionsGranted()
                      ? CallUtils.dialVideo(
                          from: sender,
                          to: receiver,
                          context: context,
                        )
                      // ignore: unnecessary_statements
                      : {};
                },
              ),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: <Widget>[
              _buildConversationImage(),
              _buildTitleAndLatestMessage(context),
            ],
          ),
        ),
        endActionPane: ActionPane(
          key: const ValueKey(0),
          dismissible: DismissiblePane(onDismissed: () {}),
          motion: DrawerMotion(),
          children: <Widget>[
            if (delete == true)
              Container(
                padding: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: SlidableAction(
                  //borderRadius: BorderRadius.all(Radius.circular(50)),
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.phone,
                  //label: 'Phone',
                  onPressed: (value) {
                    _userCollection
                        .doc(_auth.currentUser!.uid)
                        .collection(CONVERSATION_COLLECTION)
                        .doc(receiver!.userId)
                        .delete();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  _buildTitleAndLatestMessage(context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildConverastionTitle(context),
            SizedBox(height: 2),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildLatestMessage(),
                  _buildTimeOfLatestMessage()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildConverastionTitle(context) {
    return Text(
      userName!,
      style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold),
    );
  }

  _buildLatestMessage() {
    return subtitle;
  }

  _buildTimeOfLatestMessage() {
    return time != null ? time : Container();
  }

  _buildConversationImage() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
      margin: EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          ClipOval(
            child: profileImage(imageUrl),
          ),
          OnlineDotIndicator(
            uid: conversationId,
          ),
        ],
      ),
    );
  }

  Widget profileImage(_imageUrl) {
    if (_imageUrl == '') {
      return Image.asset(
        'assets/images/account.png',
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: CachedNetworkImageProvider(_imageUrl),
        fit: BoxFit.cover,
      );
    }
  }
}
