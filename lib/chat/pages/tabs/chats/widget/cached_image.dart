import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final bool? isRound;
  final double? radius;
  final double? height;
  final double? width;

  final BoxFit fit;

  CachedImage(
    this.imageUrl, {
    this.isRound = false,
    this.radius = 0,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    try {
      if (imageUrl != '') {
        return SizedBox(
          height: isRound! ? radius : height,
          width: isRound! ? radius : width,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(isRound! ? 50 : radius!),
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: fit,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/account.png',
                  fit: fit,
                ),
              )),
        );
      } else {
        return SizedBox(
          height: isRound! ? radius : height,
          width: isRound! ? radius : width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isRound! ? 50 : radius!),
            child: Image.asset(
              'assets/images/account.png',
              fit: fit,
            ),
          ),
        );
      }
    } catch (e) {
      // print(e);
      return Image.asset(
        'assets/images/account.png',
        fit: fit,
      );
    }
  }
}
