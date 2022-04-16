import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class Ho  extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Ho> {

  final FirebaseStorage storage = FirebaseStorage.instanceFor(
      app: FirebaseFirestore.instance.app,
      bucket: 'gs://testcrd-d35fe.appspot.com'
      );

  Uint8List imageBytes;
  String errorMsg;

  _MyHomePageState() {
    storage.ref().child('image1.jpg').getData(10000000).then((data) =>
        setState(() {
          imageBytes = data;
        })
    ).catchError((e) =>
        setState(() {
          errorMsg = e.error;
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    var img = imageBytes != null ? Image.memory(
      imageBytes,
      fit: BoxFit.cover,
    ) : Text(errorMsg != null ? errorMsg : "Loading...");

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("list"),
        ),
        body: new ListView(
          children: <Widget>[
            img,
          ],
        ));
}
}