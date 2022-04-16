import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:badges/badges.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/models/user_model.dart';
import 'package:group_chat_app/pages/lib/chat/chatting_screen.dart';
import 'package:group_chat_app/pages/lib/chat/message.dart';
import 'package:group_chat_app/pages/lib/chat/new_chat.dart';
import 'package:timeago/timeago.dart' as timeago;

class FriendsScreen extends StatelessWidget {
  final CurrentAppUser currentuser;

  const FriendsScreen({Key key, @required this.currentuser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friends',
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
                .collection('users')
                .where(
                  'uid',
                  whereIn: currentuser.messages.isEmpty
                      ? ['placehodter']
                      : currentuser.messages,
                )
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final List<AppUser> messagesList = [];
              snapshot.data.docs.forEach((element) {
                messagesList.add(AppUser.fromMap(element.data()));
              });
              return messagesList.isEmpty
                  ? Center(
                      child: Text('Message Someone'),
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

  Widget messageItem(AppUser e) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentuser.userId)
            .collection(e.userId)
            // .orderBy('createdAt')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<Message> messagesList = [];
          snapshot.data.docs.forEach((element) {
            messagesList.add(Message.fromMap(element.data()));
          });
          int unRead = messagesList
              .where((msg) {
                if (msg.ownerId != currentuser.userId) {
                  if (!(msg.seen)) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              })
              .toList()
              .length;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
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
                        //  style: TextStyle(color: primaryColor),
                      ),
                      // Text(
                      //   timeago.format(
                      //       DateTime.parse(
                      //         messagesList.last.createdAt,
                      //       ),
                      //       locale: 'en_long'),
                      //   style: const TextStyle(
                      //       fontSize: 9, fontWeight: FontWeight.w300),
                      // )
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       width: MediaQuery.of(context).size.width - 120,
                  //       child: Text(
                  //         messagesList.last.message,
                  //         overflow: TextOverflow.ellipsis,
                  //         style: const TextStyle(
                  //             fontSize: 13, fontWeight: FontWeight.w300),
                  //       ),
                  //     ),
                  // if (unRead > 0)
                  //   Badge(
                  //     // badgeColor: primaryColor,
                  //     badgeContent: Text(
                  //       '$unRead',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  //   ],
                  // ),
                ],
              ),
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.account_circle,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          );
        });
  }

  void onMsgItemtab(AppUser e, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChattingScreen(
        appUser: e,
        currentUser: currentuser,
      ),
    ));
  }
}
