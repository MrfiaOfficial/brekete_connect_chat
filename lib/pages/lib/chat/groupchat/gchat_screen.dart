import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/models/group_chat.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/models/user_model.dart';
import 'package:group_chat_app/pages/lib/chat/groupchat/create_group.dart';
import 'package:group_chat_app/pages/lib/chat/groupchat/gchatting_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupChatScreen extends StatelessWidget {
  final CurrentAppUser currentuser;

  const GroupChatScreen({Key key, @required this.currentuser})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateGroup()));
        },
        child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 22,
            child: Icon(Icons.add, color: Colors.white)),
      ),
      appBar: AppBar(
        title: Text(
          'Groups',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: StatefulBuilder(builder: (context, state) {
        CurrentAppUser.currentUserData.addListener(() {
          state(() {});
        });
        return SizedBox(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('groupchat')
                .where('members', arrayContainsAny: [
              CurrentAppUser.currentUserData.userId
            ]).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final List<GroupChat> messagesList = [];
              snapshot.data.docs.forEach((element) {
                messagesList.add(GroupChat.fromMap(element.data()));
              });
              return messagesList.isEmpty
                  ? Center(
                      child: Text('No group joined yet'),
                    )
                  : ListView(
                      children: messagesList.map((e) {
                        return messagesList.first == e
                            ? Column(children: [messageItem(e)])
                            : messageItem(e);
                      }).toList(),
                    );
            },
          ),
        );
      }),
    );
  }

  Widget messageItem(GroupChat e) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(e.lastMessageby)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            AppUser user = AppUser.fromMap(snapshot.data.data());

            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            // final List<Message> messagesList = [];
            // snapshot.data.docs.forEach((element) {
            //   messagesList.add(Message.fromMap(element.data()));
            //  });

            // int unRead = messagesList
            //     .where((msg) {
            //       if (msg.ownerId != currentuser.userId) {
            //         if (!(msg.seen)) {
            //           return true;
            //         } else {
            //           return false;
            //         }
            //       } else {
            //         return false;
            //       }
            //     })
            //     .toList()
            //     .length;

            return ListTile(
              onTap: () {
                onMsgItemtab(e, context);
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.name,
                      ),
                      Text(
                        timeago.format(
                            DateTime.parse(
                                e.lastMessageTime.toDate().toIso8601String()),
                            locale: 'en_long'),
                        style: const TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(
                          e.lastMessage,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFF527DAA),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'images/people.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            );
          }),
    );
  }

  void onMsgItemtab(GroupChat g, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GroupChattingScreen(
        currentUser: currentuser,
        chats: g,
      ),
    ));
  }
}
