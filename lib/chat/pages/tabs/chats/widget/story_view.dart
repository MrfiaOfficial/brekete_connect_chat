import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/models/user_model.dart';
import 'package:brekete_connect/chat/packages/story_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:brekete_connect/chat/pages/tabs/stories/widgets/story_card.dart';
import 'package:brekete_connect/chat/services/auth_firebase.dart';
import 'package:flutter/material.dart';

class StoryView extends StatefulWidget {
  final String? userId;
  StoryView({Key? key, this.userId}) : super(key: key);

  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  final _momentDuration = const Duration(seconds: 5);

  final AuthFirebase _authFirebase = AuthFirebase();

  List<Color> currentColors = [
    Colors.limeAccent,
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.amber,
    Colors.yellow
  ];

  Random random = new Random();

  int index = 0;

  @override
  void initState() {
    super.initState();
    changeColor();
  }

  void changeColor() {
    if (index == 6) {
      setState(() => index = 0);
    } else {
      setState(() => index = random.nextInt(6));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection(STORY_COLLECTION)
        .doc(widget.userId)
        .collection(STORY_COLLECTION)
        .snapshots();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Story(
              onFlashForward: Navigator.of(context).pop,
              onFlashBack: Navigator.of(context).pop,
              momentDurationGetter: (i) => _momentDuration,
              momentCount: snapshot.data!.docs.length,
              momentBuilder: (context, i) =>
                  _listStory(snapshot.data!.docs[i], context),
            );
          }),
    );
  }

  Widget _listStory(DocumentSnapshot documentSnapshot, context) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    final mq = MediaQuery.of(context);
    if (data['Type'] == 'image') {
      return Container(
        child: Stack(
          children: <Widget>[
            InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Container(
                  constraints: BoxConstraints(
                    maxHeight: mq.size.height,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child: CachedNetworkImage(
                      imageUrl: data['Urls']!, fit: BoxFit.contain)),
            ),
            PostedData(stream: _authFirebase.getUserStream(uid: widget.userId)),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    bottom: 24,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  color: Colors.black,
                  child: data['Content'].toString() != ''
                      ? Text(
                          data['Content'],
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : SizedBox(),
                ),
              ),
            )
          ],
        ),
      );
    } else if (data['Type'] == 'text') {
      return Container(
        color: currentColors[index],
        child: Stack(
          children: [
            PostedData(stream: _authFirebase.getUserStream(uid: widget.userId)),
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  // height: double.infinity,
                  margin: EdgeInsets.only(
                    top: 40,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  color: Colors.transparent,
                  child: data['Content'].toString() != ''
                      ? Text(
                          data['Content'],
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : SizedBox(),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class PostedData extends StatelessWidget {
  final stream;
  const PostedData({required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? _userData;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (snapshot.hasData && snapshot.data!.data() != null) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              _userData = UserData.fromMap(data);
            }

            if (_userData!.img == null || _userData.img!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    child: Image.asset(
                      'assets/images/account.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    _userData.username.toString(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 0),
                child: ListTile(
                  leading: Avatar(
                    imageUrl: _userData.img,
                  ),
                  title: Text(
                    _userData.username.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
          }
          return Text(
            "...",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        });
  }
}
