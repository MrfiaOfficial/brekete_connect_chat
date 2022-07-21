import 'package:cached_network_image/cached_network_image.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReplyMessagePreview extends StatelessWidget {
  const ReplyMessagePreview({
    Key? key,
    required this.repliedMessage,
    required this.userId,
    required this.reply,
    required this.peerName,
    required this.onCanceled,
  }) : super(key: key);

  final Message? repliedMessage;
  final String? userId;
  final String? peerName;
  final bool reply;
  final VoidCallback onCanceled;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: _Leading(
                repliedMessage: repliedMessage!,
                userId: userId!,
                peerName: peerName!),
          ),
          Flexible(
            child: _Trailing(
                repliedMessage: repliedMessage!, onCanceled: onCanceled),
          ),
        ],
      ),
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({
    Key? key,
    required this.repliedMessage,
    required this.onCanceled,
  }) : super(key: key);

  final Message? repliedMessage;
  final VoidCallback onCanceled;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: repliedMessage!.type == MessageType.Text ? 54 : 130,
      ),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (repliedMessage!.type == MessageType.Media)
            repliedMessage!.mediaType == MediaType.File
                ? Container(
                    width: 40,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      image: new DecorationImage(
                        image: new AssetImage(
                            'assets/images/${repliedMessage!.extensionfile}.png'),
                      ),
                    ),
                  )
                : repliedMessage!.mediaType == MediaType.Photo
                    ? Container(
                        width: 40,
                        height: 50,
                        child: CachedNetworkImage(
                          imageUrl: repliedMessage!.mediaUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 40,
                        height: 50,
                        child: Icon(
                          Icons.video_collection,
                          size: 20,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
          SizedBox(width: 10),
          CupertinoButton(
            padding: const EdgeInsets.only(
              left: 0,
              top: 0,
              bottom: 0,
              right: 10,
            ),
            onPressed: onCanceled,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.close,
                  color: Theme.of(context).accentColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({
    Key? key,
    required this.repliedMessage,
    required this.userId,
    required this.peerName,
  }) : super(key: key);

  final Message? repliedMessage;
  final String? userId;
  final String? peerName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: RichText(
            text: TextSpan(
              text: 'Replying to ',
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).accentColor.withOpacity(0.87)
                  // fontWeight: FontWeight.w600,
                  ),
              children: [
                TextSpan(
                  text:
                      repliedMessage!.fromId == userId ? 'yourself' : peerName,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).accentColor.withOpacity(0.87),
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        Flexible(
          child: SizedBox(
              height: repliedMessage!.type == MessageType.Text ? 5 : 0),
        ),
        Flexible(
            child: repliedMessage!.type == MessageType.Text
                ? Text(
                    repliedMessage!.content!,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    overflow: TextOverflow.ellipsis,
                  )
                : repliedMessage!.mediaType == MediaType.File
                    ? Container(
                        height: 30,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.file_present,
                              size: 20,
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(width: 5),
                            Text('Document')
                          ],
                        ),
                      )
                    : repliedMessage!.mediaType == MediaType.Photo
                        ? Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Theme.of(context).accentColor,
                                ),
                                SizedBox(width: 5),
                                Text('Photo')
                              ],
                            ),
                          )
                        : Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.video_collection,
                                  size: 20,
                                  color: Theme.of(context).accentColor,
                                ),
                                SizedBox(width: 5),
                                Text('Video')
                              ],
                            ),
                          )),
      ],
    );
  }
}
