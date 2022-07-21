import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/models/ChatData.dart';
import 'package:brekete_connect/chat/models/message.dart';
import 'package:brekete_connect/chat/pages/tabs/chat_screen/chat_screen.dart';
import 'package:brekete_connect/chat/pages/tabs/chat_screen/widget/app_bar.dart';
import 'package:brekete_connect/chat/providers/chat.dart';
import 'package:brekete_connect/chat/services/db.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListItem extends StatefulWidget {
  final ChatData chatData;

  ChatListItem({Key? key, required this.chatData})
      : super(key: GlobalKey<_ChatListItemState>());
  @override
  _ChatListItemState createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  // GlobalKey key = GlobalKey<_ChatItemState>();
  late DB db;
  List<dynamic> unreadMessages = [];
  // int unreadCount;
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DB();
    _stream = db.getSnapshotsWithLimit(widget.chatData.groupId!, 1);
  }

  // String? getDate() {
  //   DateTime date = DateTime.now();
  //   return DateFormat.yMd(date).toString();
  // }

  // add new messages to ChatData and update unread count
  void _addNewMessages(Message newMsg) {
    // final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    if (widget.chatData.messages.isEmpty ||
        newMsg.sendDate!.isAfter(widget.chatData.messages[0].sendDate)) {
      widget.chatData.addMessage(newMsg);

      if (newMsg.fromId != widget.chatData.userId) {
        widget.chatData.unreadCount++;

        // play notification sound
        // if(widget.initChatData.messages.isNotEmpty && widget.initChatData.messages[0].sendDate != newMsg.sendDate)
        // if(isIos)
        //   Utils.playSound('mp3/notificationIphone.mp3');
        // else Utils.playSound('mp3/notificationAndroid.mp3');

        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          Provider.of<Chat>(context, listen: false)
              .bringChatToTop(widget.chatData.groupId!);
          setState(() {});
        });
      }
    }
  }

  void navToChatScreen() {
    widget.chatData.unreadCount = 0;
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: ChatScreen(
              chatData: widget.chatData,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final peer = widget.chatData.peer;
    return Material(
      key: UniqueKey(),
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Theme.of(context).accentColor,
        onTap: navToChatScreen,
        child: Container(
          height: 80,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: Avatar(
              imageUrl: widget.chatData.peer.img!,
              radius: 27,
            ),
            title: Text(
              peer.username!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).accentColor,
              ),
            ),
            subtitle: _PreviewText(
              stream: _stream,
              onNewMessageRecieved: _addNewMessages,
              peerId: widget.chatData.peerId,
              userId: widget.chatData.userId,
            ),
            trailing: _UnreadCount(
              unreadCount: widget.chatData.unreadCount,
              lastMessage: widget.chatData.messages[0],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewText extends StatelessWidget {
  _PreviewText({
    Key? key,
    required this.stream,
    this.peerId,
    this.userId,
    this.onNewMessageRecieved,
  }) : super(key: key);

  final Stream<QuerySnapshot> stream;
  final String? peerId;
  final String? userId;
  final Function? onNewMessageRecieved;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting)
          return Container(height: 0, width: 0);
        else {
          if (snapshots.data!.docs.isNotEmpty) {
            final snapshot = snapshots.data!.docs[0];
            Map<String, dynamic> data =
                snapshot.data()! as Map<String, dynamic>;
            Message newMsg = Message.fromMap(data);
            onNewMessageRecieved!(newMsg);
            return Row(
              children: [
                newMsg.type == MessageType.Media
                    ? Container(
                        child: Row(
                          children: [
                            Icon(
                              newMsg.mediaType == MediaType.Photo
                                  ? Icons.photo_camera
                                  : newMsg.mediaType == MediaType.File
                                      ? Icons.file_present_sharp
                                      : Icons.videocam,
                              size:
                                  newMsg.mediaType == MediaType.Photo ? 15 : 20,
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.45),
                            ),
                            SizedBox(width: 8),
                            Text(
                                newMsg.mediaType == MediaType.Photo
                                    ? 'Photo'
                                    : newMsg.mediaType == MediaType.File
                                        ? 'Document'
                                        : 'Video',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.7),
                                ))
                          ],
                        ),
                      )
                    : Flexible(
                        child: Text(newMsg.content!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                if (newMsg.fromId != peerId) ...[
                  SizedBox(width: 5),
                  Icon(
                    Icons.done_all,
                    size: 19,
                    color: newMsg.isSeen!
                        ? Color(0xFF4bd8a4)
                        : Theme.of(context).accentColor.withOpacity(0.7),
                  ),
                ],
              ],
            );
          } else
            return Container(height: 0, width: 0);
        }
      },
    );
  }
}

class _UnreadCount extends StatelessWidget {
  const _UnreadCount({
    Key? key,
    required this.unreadCount,
    this.lastMessage,
  }) : super(key: key);

  final int unreadCount;
  final Message? lastMessage;

  _ago(DateTime t) {
    return timeago.format(t);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (lastMessage != null)
          Text(_ago(lastMessage!.sendDate!),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).accentColor.withOpacity(0.7),
              )),
        // ignore: unnecessary_null_comparison
        if (unreadCount != null && unreadCount > 0) ...[
          SizedBox(height: 5),
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).backgroundColor.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                '$unreadCount',
                style: TextStyle(
                  color: Color(0xFF4bd8a4),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
