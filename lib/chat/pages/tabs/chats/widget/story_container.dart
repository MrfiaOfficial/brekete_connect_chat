import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

import '../../../post_story_text.dart';
import '../../../selected_media_story_post.dart';
import 'story_view.dart';

class StoriesContainer extends StatefulWidget {
  StoriesContainer({Key? key}) : super(key: key);

  @override
  _StoriesContainerState createState() => _StoriesContainerState();
}

class _StoriesContainerState extends State<StoriesContainer> {
  TextEditingController textFieldController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future pickerImage({required ImageSource? src}) async {
    var pickedFile = await Utils.pickedImage(context, src);
    if (pickedFile != null) {
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: SelectedMediaStoryPost(
              file: File(pickedFile.path),
              pickedMediaType: MediaType.Photo,
              textEditingController: textFieldController,
              onClosed: () => Navigator.of(context).pop(),
            ),
          ));
    }
  }

  // Show the option of Chooice the camera
  void _statusPicker(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0))),
        backgroundColor: Theme.of(context).backgroundColor,
        builder: (BuildContext context) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: new Container(
                    height: 8.00,
                    width: 60.00,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      border: Border.all(
                        width: 1.00,
                        color: Color(0xffb5b2b2),
                      ),
                      borderRadius: BorderRadius.circular(4.00),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: PostTextStory())),
                      child: Column(
                        children: [
                          new Icon(
                            Icons.text_fields,
                            size: 50,
                          ),
                          new Text('Text')
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => pickerImage(src: ImageSource.gallery),
                      child: Column(
                        children: [
                          new Icon(Icons.image, size: 40),
                          new Text('Image')
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        children: [
                          new Icon(Icons.video_camera_back, size: 40),
                          new Text('Video')
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _buildItemStories(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data['UserId'].toString() != auth.currentUser!.uid
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: StoryView(
                            userId: data['UserId'],
                          )));
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Color(0xFF4bd8a4), width: 1.5),
                  ),
                  child: ImageAvatar(
                    context: context,
                    postedBy: data['UserId'].toString(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 54,
                child: Center(
                  child: UserNameStories(
                    context: context,
                    postedBy: data['UserId'].toString(),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _empty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(0),
          onPressed: () => _statusPicker(context),
          child: Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                radius: 27,
              ),
              Positioned(
                bottom: 4,
                right: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Your Story',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyStoryItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data['UserId'].toString() == auth.currentUser!.uid
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: StoryView(
                            userId: auth.currentUser!.uid,
                          )));
                },
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border:
                            Border.all(color: Color(0xFF4bd8a4), width: 1.5),
                      ),
                      child: ImageAvatar(
                        context: context,
                        postedBy: auth.currentUser!.uid,
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 3,
                      child: GestureDetector(
                        onTap: () => _statusPicker(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Your Story',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => _statusPicker(context),
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      radius: 27,
                    ),
                    Positioned(
                      bottom: 4,
                      right: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Your Story',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection(STORY_COLLECTION)
        .orderBy('Date', descending: true)
        .snapshots();
    return Container(
      height: 100,
      child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }
            if (!snapshot.hasData) {
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 15),
              scrollDirection: Axis.horizontal,
              itemCount: 1 + snapshot.data!.docs.length,
              itemBuilder: (ctx, i) => i == 0
                  ? snapshot.data!.docs.isEmpty
                      ? _empty()
                      : _buildMyStoryItem(snapshot.data!.docs[i])
                  : _buildItemStories(snapshot.data!.docs[i - 1]),
              separatorBuilder: (_, __) => SizedBox(width: 20),
            );
          }),
    );
  }
}

class UserNameStories extends StatelessWidget {
  final String? postedBy;
  const UserNameStories(
      {Key? key, required this.context, required this.postedBy})
      : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(postedBy).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text(
              data['Username'].split(' ')[0],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).accentColor,
              ),
            );
          }
          return Container();
        });
  }
}

class ImageAvatar extends StatelessWidget {
  final String? postedBy;
  const ImageAvatar({
    Key? key,
    required this.context,
    required this.postedBy,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(postedBy).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              backgroundImage: (data['img'] != null && data['img'] != '')
                  ? CachedNetworkImageProvider(data['img'])
                  : null,
              child: (data['img'] == null || data['img'] == '')
                  ? Image.asset(
                      'assets/images/account.png',
                      fit: BoxFit.cover,
                    )
                  : null,
              radius: 27,
            );
          }
          return Container();
        });
  }
}
