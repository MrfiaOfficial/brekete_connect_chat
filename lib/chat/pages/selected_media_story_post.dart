import 'dart:io';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/constants/strings.dart';
import 'package:brekete_connect/chat/models/loading.dart';
import 'package:brekete_connect/chat/models/modal_progress_hub.dart';
import 'package:brekete_connect/chat/models/story_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class SelectedMediaStoryPost extends StatefulWidget {
  final File? file;
  final TextEditingController? textEditingController;
  final VoidCallback onClosed;
  final MediaType pickedMediaType;
  SelectedMediaStoryPost({
    required this.file,
    required this.textEditingController,
    required this.onClosed,
    required this.pickedMediaType,
  });

  @override
  _SelectedMediaStoryPostState createState() => _SelectedMediaStoryPostState();
}

class _SelectedMediaStoryPostState extends State<SelectedMediaStoryPost> {
  CollectionReference story =
      FirebaseFirestore.instance.collection(STORY_COLLECTION);
  final FirebaseAuth auth = FirebaseAuth.instance;
  late StoryModal _storyModal;

  final _char = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  bool _isAsyncCall = false;
  bool _isbackPop = true;
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _char.codeUnitAt(_rnd.nextInt(_char.length))));

  Future<dynamic> postImage(fileUrl) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('imageStatus/')
        .child(getRandomString(8));
    try {
      await ref.putFile(fileUrl);
      // print(ref.getDownloadURL());
      return ref.getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      setState(() {
        _isAsyncCall = false;
        _isbackPop = true;
      });
      Flushbar(
        message: e.message,
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.green[500],
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.white,
      )..show(context);
      // e.g, e.code == 'canceled'
    }
  }

  Future<void> send() async {
    if (widget.file != null) {
      setState(() {
        setState(() {
          _isAsyncCall = true;
          _isbackPop = false;
        });
      });
      postImage(widget.file).then((downloadUrl) {
        _storyModal = StoryModal(
          content: widget.textEditingController!.text,
          postedBy: auth.currentUser!.uid,
          urls: downloadUrl,
          type: 'image',
          date: DateTime.now().toString(),
        );
        story.doc(auth.currentUser!.uid).set({
          'UserId': auth.currentUser!.uid,
          'Date': DateTime.now().toString()
        }, SetOptions(merge: true)).then((value) {
          story
              .doc(auth.currentUser!.uid)
              .collection(STORY_COLLECTION)
              .add(_storyModal.toJson())
              .then((_) {
            setState(() {
              _isAsyncCall = false;
              _isbackPop = true;
            });
            Navigator.pop(context);
            widget.textEditingController!.clear();
          }).catchError((onError) {
            setState(() {
              _isAsyncCall = false;
              _isbackPop = true;
            });
            Flushbar(
              message: onError.toString(),
              icon: Icon(
                Icons.error_outline,
                size: 28.0,
                color: Colors.green[500],
              ),
              duration: Duration(seconds: 3),
              leftBarIndicatorColor: Colors.white,
            )..show(context);
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => _isbackPop,
        child: ModalProgressHUD(
          child: Container(
              constraints: BoxConstraints(
                maxHeight: mq.size.height,
              ),
              child: LayoutBuilder(builder: (ctx, constraints) {
                return Stack(
                  children: [
                    _SelectedMedia(
                        mediaType: widget.pickedMediaType, file: widget.file!),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CupertinoButton(
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              child: Icon(Icons.close,
                                  color: Colors.white, size: 20),
                            ),
                            onPressed: widget.onClosed,
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          width: size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: _InputField(
                                  controller: widget.textEditingController,
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  child: Icon(Icons.send,
                                      size: 30, color: Colors.white),
                                  onPressed: () {
                                    send();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              })),
          inAsyncCall: _isAsyncCall,
          progressIndicator: LoadingCustom(
            radius: 40,
          ),
          opacity: 0.3,
        ),
      ),
    );
  }
}

class _SelectedMedia extends StatelessWidget {
  final MediaType mediaType;
  final File file;
  const _SelectedMedia({
    Key? key,
    required this.mediaType,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.center,
        height: size.height,
        width: double.infinity,
        child: mediaType == MediaType.Photo
            ? Image.file(
                file,
                fit: BoxFit.contain,
                height: size.height,
                width: double.infinity,
              )
            : null
        // CVideoPlayer(video: file, isLocal: true),
        );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withOpacity(0.7),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 5),
          Flexible(
            child: TextField(
              maxLines: null,
              style: TextStyle(
                  fontSize: 16, color: Colors.white.withOpacity(0.95)),
              controller: controller,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              cursorColor: Theme.of(context).accentColor,
              keyboardAppearance: Brightness.dark,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                border: InputBorder.none,
                hintText: 'Add a caption...',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              // onSubmitted: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
