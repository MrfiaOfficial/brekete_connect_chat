import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_chat/Widgets/app_bar_widget.dart';
import 'package:connect_chat/Widgets/pop_box.dart';
import 'package:connect_chat/constants/strings.dart';
import 'package:connect_chat/models/ChatData.dart';
import 'package:connect_chat/providers/chat.dart';
import 'package:connect_chat/services/db.dart';
import 'package:connect_chat/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../post_story_text.dart';
import '../../selected_media_story_post.dart';
import 'widget/body_list.dart';
import 'widget/chat_item_list.dart';
import 'widget/story_container.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  DB db = DB();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController textFieldController = TextEditingController();

  Future pickerImage({required ImageSource? src}) async {
    var pickedFile = await Utils.pickedImage(context, src);
    if (pickedFile != null) {
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
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

  void updateChats(BuildContext context, AsyncSnapshot<dynamic> snapshots) {
    if (snapshots.data != null) {
      final currentContacts = context.watch<Chat>().getContacts;
      final currContactLength = currentContacts.length;
      final contacts = snapshots.data['contacts'];
      if (contacts != null) if (contacts.length > currContactLength) {
        context.read<Chat>().handleMessagesNotFromContacts(contacts);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final chats = Provider.of<Chat>(context).chats;
    final isLoading = Provider.of<Chat>(context).isLoading;
    return StreamBuilder<DocumentSnapshot>(
        stream: db.getUserContactsStream(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (!isLoading && snapshot.hasData) updateChats(context, snapshot);
          return Column(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppBarWidget(
                      tiltleName: "Chats",
                      actions: [
                        Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(100.0)),
                            child: IconButton(
                                icon: Icon(Icons.add_circle,
                                    color: Theme.of(context).accentColor),
                                onPressed: () => _statusPicker(context))),
                      ],
                    ),
                    SizedBox(height: 15),
                    StoriesContainer(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              isLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : context.watch<Chat>().chats.isEmpty
                      ? PopBox(
                          heading: "All chat conversation are listed here?")
                      : _buildChats(chats),
            ],
          );
        });
  }

  Widget _buildChats(List<ChatData> chats) => BodyList(
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 10),
          itemCount: chats.length,
          itemBuilder: (ctx, i) => ChatListItem(chatData: chats[i]),
          separatorBuilder: (ctx, i) {
            return Divider(
              indent: 20,
              endIndent: 15,
              height: 0,
              thickness: 1,
              color: Theme.of(context).accentColor.withOpacity(0.1),
            );
          },
        ),
      );

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
