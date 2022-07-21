import 'dart:io';
import 'dart:math';

import 'package:brekete_connect/chat/Widgets/video_player.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/models/message.dart';
import 'package:brekete_connect/chat/services/storage_firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';

class MediaUploadingBubble extends StatefulWidget {
  final String? groupId;
  final File? file;
  final String? extensionfile;
  final String? fileName;
  final String? fileSize;
  final DateTime time;
  final Function? onUploadFinished;
  final Message message;
  final MediaType mediaType;
  MediaUploadingBubble({
    required this.groupId,
    required this.file,
    required this.time,
    required this.onUploadFinished,
    required this.message,
    required this.mediaType,
    this.extensionfile,
    this.fileName,
    this.fileSize,
  });
  @override
  _MediaUploadingBubbleState createState() => _MediaUploadingBubbleState();
}

class _MediaUploadingBubbleState extends State<MediaUploadingBubble> {
  StorageFirebase storageFirebase = StorageFirebase();

  bool uploadStarted = false;
  var timestamp;
  String? path;

  bool progress = false;
  @override
  void initState() {
    super.initState();
    onUploadCompleted();
  }

  void onUploadCompleted() async {
    setState(() {
      progress = true;
    });
    String? url = await storageFirebase.uploadToStorage(widget.file!.path);
    widget.onUploadFinished!(url);
    setState(() {
      progress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(5),
        // height: size.height * 0.35,
        width: size.width * 0.7,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          alignment: WrapAlignment.end,
          runAlignment: WrapAlignment.spaceBetween,
          children: [
            Wrap(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: widget.mediaType == MediaType.File
                              ? size.height / 9
                              : size.height * 0.35,
                          maxWidth: size.width * 0.7,
                        ),
                        height: double.infinity,
                        width: double.infinity,
                        child: widget.mediaType == MediaType.Video
                            ? CVideoPlayer(video: widget.file, isLocal: true)
                            : widget.mediaType == MediaType.File
                                ? FileContainer(
                                    fileName: widget.fileName,
                                    fileSize: widget.fileSize,
                                    extensionfile: widget.extensionfile,
                                  )
                                : Image.file(widget.file!,
                                    fit: BoxFit.cover,
                                    width: size.width * 0.7,
                                    height: size.height * 0.35),
                      ),
                    ),
                    progress
                        ? Container(
                            height: widget.mediaType == MediaType.File
                                ? size.height / 9
                                : size.height * 0.35,
                            width: size.width * 0.7,
                            color: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.54),
                            child: Center(child: CupertinoActivityIndicator()),
                          )
                        : Container(height: 0, width: 0),
                    if (widget.message.content == null ||
                        widget.message.content == '')
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: BottomDetails(message: widget.message),
                      ),
                  ],
                ),
                if (widget.message.content != null &&
                    widget.message.content != '')
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 1),
                    child: _buildBubbleContent(context),
                  )
              ],
            ),
            if (widget.message.content != null && widget.message.content != '')
              Padding(
                padding: const EdgeInsets.only(bottom: 1, right: 1),
                child: _SeenStatus(message: widget.message),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleContent(BuildContext context) {
    return SelectableText(
      widget.message.content!,
      style: TextStyle(
        fontSize: 17,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}

class FileContainer extends StatelessWidget {
  final String? extensionfile;
  final String? fileName;
  final String? fileSize;
  const FileContainer({
    Key? key,
    this.extensionfile,
    this.fileName,
    this.fileSize,
  }) : super(key: key);

  static String? _prettyCountInt(String? nums) {
    int bytes = int.parse(nums!);
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
  }

  getFirstLetter(String? title) {
    return title!.substring(0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(
        minWidth: size.width * 0.7,
        maxWidth: size.width * 0.7,
        minHeight: size.height / 9,
        maxHeight: size.height / 9,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          getFirstLetter(fileName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _prettyCountInt(fileSize!).toString(),
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      image: new DecorationImage(
                        image:
                            new AssetImage('assets/images/$extensionfile.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomDetails extends StatelessWidget {
  final Message message;
  const BottomDetails({
    Key? key,
    required this.message,
  }) : super(key: key);

  Widget _buildSeenStatus(BuildContext context) =>
      _SeenStatus(message: message);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(5),
      height: 30,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.01),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: _buildSeenStatus(context),
    );
  }
}

class _SeenStatus extends StatelessWidget {
  const _SeenStatus({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  getTime() {
    return timeago.format(message.sendDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            getTime(),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).accentColor.withOpacity(0.6),
            ),
          ),
        ),
        SizedBox(width: 5),
        Icon(
          Icons.done_all,
          color: (message.isSeen != null && message.isSeen!)
              ? Theme.of(context).accentColor
              : Colors.white.withOpacity(0.35),
          size: 17,
        ),
      ],
    );
  }
}
