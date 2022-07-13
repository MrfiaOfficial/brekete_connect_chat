import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_chat/Widgets/media_view.dart';
import 'package:connect_chat/Widgets/video_player.dart';
import 'package:connect_chat/constants/strings.dart';
import 'package:connect_chat/models/message.dart';
import 'package:connect_chat/pages/tabs/chat_screen/widget/view_file.dart';
import 'package:connect_chat/providers/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'app_bar.dart';
import 'bubble_text.dart';
import 'dismissible_bubble.dart';
import 'media_uploading_bubble.dart';
import 'seen_status.dart';

class MediaBubble extends StatelessWidget {
  final Message message;
  final Function onReplied;
  final String avatarImageUrl;

  const MediaBubble({
    Key? key,
    required this.message,
    required this.onReplied,
    required this.avatarImageUrl,
  }) : super(key: key);

  void navToImageView(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (message.mediaType == MediaType.File) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: ViewFile(
                fileUrl: message.mediaUrl,
                name: message.fileName,
                extensions: message.extensionfile,
                size: message.fileSize,
                platform: platform,
              )));
    } else {
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MediaView(url: message.mediaUrl!, type: message.mediaType!),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = 0.0;
          var end = 1.0;
          var tween = Tween(begin: begin, end: end);
          var fadeAnimation = animation.drive(tween);
          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMe =
        Provider.of<Chat>(context, listen: false).getUserId == message.fromId;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe) Avatar(imageUrl: avatarImageUrl),
        if (!isMe) SizedBox(width: 5),
        Flexible(
          child: Hero(
            tag: message.mediaUrl!,
            child: DismssibleBubble(
              isMe: isMe,
              message: message,
              onDismissed: onReplied,
              child: GestureDetector(
                onTap: () => navToImageView(context),
                child: Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: isMe
                          ? null
                          : (message.type == MessageType.Media &&
                                  message.content != null)
                              ? Border.all(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.2))
                              : null,
                      color: isMe
                          ? Theme.of(context).canvasColor.withOpacity(0.5)
                          : Theme.of(context).canvasColor,
                    ),
                    padding: const EdgeInsets.all(5),
                    constraints: BoxConstraints(
                      minWidth: size.width * 0.7,
                      maxWidth: size.width * 0.7,
                      minHeight: message.mediaType == MediaType.File
                          ? size.height / 9
                          : size.height * 0.35,
                      // maxHeight: mq.size.height * 0.35,
                    ),
                    child: message.content == null || message.content!.isEmpty
                        ? _WithoutText(message: message, isMe: isMe)
                        : _WithText(message: message, isMe: isMe),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WithText extends StatelessWidget {
  const _WithText({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  final Message message;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      alignment: WrapAlignment.end,
      runAlignment: WrapAlignment.spaceBetween,
      children: [
        Wrap(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: size.width * 0.7,
                  maxWidth: size.width * 0.7,
                  minHeight: message.mediaType == MediaType.File
                      ? size.height / 9
                      : size.height * 0.35,
                  maxHeight: message.mediaType == MediaType.File
                      ? size.height / 9
                      : size.height * 0.35,
                ),
                child: message.mediaType == MediaType.Video
                    ? CVideoPlayer(
                        url: message.mediaUrl,
                        isLocal: false,
                      )
                    : CachedNetworkImage(
                        imageUrl: message.mediaUrl!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: BubbleText(text: message.content)),
          ],
        ),
        SeenStatus(
          isMe: isMe,
          isSeen: message.isSeen,
          timestamp: message.sendDate,
        ),
      ],
    );
  }
}

class _WithoutText extends StatelessWidget {
  const _WithoutText({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  final Message message;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: size.width * 0.7,
            maxWidth: size.width * 0.7,
            minHeight: message.mediaType == MediaType.File
                ? size.height / 9
                : size.height * 0.35,
            maxHeight: message.mediaType == MediaType.File
                ? size.height / 9
                : size.height * 0.35,
          ),
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: message.mediaType == MediaType.Video
                ? CVideoPlayer(
                    url: message.mediaUrl,
                    isLocal: false,
                  )
                : message.mediaType == MediaType.File
                    ? FileContainer(
                        fileName: message.fileName,
                        fileSize: message.fileSize,
                        extensionfile: message.extensionfile,
                      )
                    : CachedNetworkImage(
                        imageUrl: message.mediaUrl!,
                        placeholder: (_, __) =>
                            Center(child: CupertinoActivityIndicator()),
                        fit: BoxFit.cover,
                      ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(5),
                height: 30,
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.8,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.01),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: SeenStatus(
                  isMe: isMe,
                  isSeen: message.isSeen,
                  timestamp: message.sendDate,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}