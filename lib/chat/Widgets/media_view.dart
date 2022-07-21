import 'package:cached_network_image/cached_network_image.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:flutter/material.dart';

class MediaView extends StatelessWidget {
  final String? url;
  final MediaType type;
  MediaView({
    required this.url,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: url!,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: mq.size.height,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child: type == MediaType.Photo
                      ? CachedNetworkImage(imageUrl: url!, fit: BoxFit.contain)
                      : Container(),
                  // : CVideoPlayer(url: url, isLocal: false),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
