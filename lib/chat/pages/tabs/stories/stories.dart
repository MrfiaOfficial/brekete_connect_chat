import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_chat/Widgets/app_bar_widget.dart';
import 'package:connect_chat/constants/strings.dart';
import 'package:connect_chat/models/user_model.dart';
import 'package:connect_chat/pages/tabs/chats/widget/story_view.dart';
import 'package:connect_chat/pages/tabs/stories/widgets/story_card.dart';
import 'package:connect_chat/providers/user_provider.dart';
import 'package:connect_chat/services/auth_firebase.dart';
import 'package:connect_chat/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../post_story_text.dart';
import '../../selected_media_story_post.dart';

class StoriesPage extends StatefulWidget {
  StoriesPage({Key? key}) : super(key: key);

  @override
  _StoriesPageState createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  final AuthFirebase _authFirebase = AuthFirebase();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController textFieldController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection(STORY_COLLECTION)
        .orderBy('Date', descending: true)
        .snapshots();
    return Column(
      children: [
        AppBarWidget(
          tiltleName: "Stories",
          actions: [],
        ),
        SizedBox(height: 15),
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }
                if (!snapshot.hasData) {
                  return Container();
                }
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 3),
                    itemCount: 1 + snapshot.data!.docs.length,
                    itemBuilder: (context, int index) => index == 0
                        ? snapshot.data!.docs.isEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: storyEmptyItem(true))
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: storyListItemCurrent(
                                    snapshot.data!.docs[index], false))
                        : Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: storyListItem(
                                snapshot.data!.docs[index - 1], false)));
              }),
        ),
      ],
    );
  }

  Widget storyListItemCurrent(
      DocumentSnapshot documentSnapshot, bool isAddStory) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data['UserId'].toString() == auth.currentUser!.uid
        ? Container(
            padding: EdgeInsets.only(left: 20),
            child: StoryCard(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: StoryView(
                            userId: data['UserId'],
                          )));
                },
                isAddStory: isAddStory,
                backgroundUrls: BackgroundContainer(
                    stream: FirebaseFirestore.instance
                        .collection(STORY_COLLECTION)
                        .doc(data['UserId'])
                        .collection(STORY_COLLECTION)
                        .snapshots()),
                profileImage: ImgContainer(
                  stream:
                      _authFirebase.getUserStream(uid: auth.currentUser!.uid),
                ),
                username: UsernameContainer(
                  stream:
                      _authFirebase.getUserStream(uid: auth.currentUser!.uid),
                )),
          )
        : storyEmptyItem(true);
  }

  Widget storyEmptyItem(bool isAddStory) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: StoryCard(
          onPressed: () => _statusPicker(context),
          backgroundUrls: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: CachedNetworkImage(
              imageUrl: context.watch<UserProvider>().getUser!.img.toString(),
              width: 130,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          isAddStory: isAddStory,
          profileImage: ImgContainer(
            stream: _authFirebase.getUserStream(uid: auth.currentUser!.uid),
          ),
          username: UsernameContainer(
            stream: _authFirebase.getUserStream(uid: auth.currentUser!.uid),
          )),
    );
  }

  Widget storyListItem(DocumentSnapshot documentSnapshot, bool isAddStory) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data['UserId'].toString() != auth.currentUser!.uid
        ? Container(
            padding: EdgeInsets.only(left: 20),
            child: StoryCard(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: StoryView(
                            userId: data['UserId'],
                          )));
                },
                isAddStory: isAddStory,
                backgroundUrls: BackgroundContainer(
                    stream: FirebaseFirestore.instance
                        .collection(STORY_COLLECTION)
                        .doc(data['UserId'])
                        .collection(STORY_COLLECTION)
                        .snapshots()),
                profileImage: ImgContainer(
                  stream: _authFirebase.getUserStream(uid: data['UserId']),
                ),
                username: UsernameContainer(
                  stream: _authFirebase.getUserStream(uid: data['UserId']),
                )),
          )
        : Container();
  }
}

class UsernameContainer extends StatelessWidget {
  final stream;
  const UsernameContainer({required this.stream});

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
            return Text(
              _userData!.username.toString().split(' ')[0],
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            );
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

class ImgContainer extends StatelessWidget {
  final stream;
  const ImgContainer({required this.stream});

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
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  child: Image.asset(
                    'assets/images/account.png',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              return Avatar(
                imageUrl: _userData.img,
                // hasBorder: !story.isViewed,
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

class BackgroundContainer extends StatelessWidget {
  final stream;
  const BackgroundContainer({required this.stream});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          final image = snapshot.data!.docs[0];
          Map<String, dynamic> data = image.data() as Map<String, dynamic>;
          return data['Type'] != 'text'
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: data["Urls"],
                    width: 130,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 130,
                  child: Center(
                    child: Text(
                      data['Content'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
        });
  }
}
