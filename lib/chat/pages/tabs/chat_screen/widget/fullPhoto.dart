// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';

// class FullPhoto extends StatelessWidget {
//   final String? url;
//   FullPhoto({Key? key, required this.url}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FullPhotoScreen(url: url);
//   }
// }

// class FullPhotoScreen extends StatefulWidget {
//   final String? url;

//   FullPhotoScreen({Key? key, required this.url}) : super(key: key);

//   @override
//   State createState() => new FullPhotoScreenState();
// }

// class FullPhotoScreenState extends State<FullPhotoScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: PhotoView(
//       imageProvider: NetworkImage(widget.url!),
//       initialScale: PhotoViewComputedScale.contained,
//       loadingBuilder: (context, progress) => Center(
//           child: Container(
//               width: 20.0, height: 20.0, child: CircularProgressIndicator())),
//     ));
//   }
// }
