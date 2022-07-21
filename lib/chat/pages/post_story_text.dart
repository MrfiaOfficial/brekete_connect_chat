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

class PostTextStory extends StatefulWidget {
  PostTextStory({Key? key}) : super(key: key);

  @override
  _PostTextStoryState createState() => _PostTextStoryState();
}

class _PostTextStoryState extends State<PostTextStory> {
  CollectionReference story =
      FirebaseFirestore.instance.collection(STORY_COLLECTION);
  TextEditingController _textEditingController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  FocusNode _textFieldFocusNode = FocusNode();
  Color currentColor = Colors.limeAccent;
  List<Color> currentColors = [
    Colors.limeAccent,
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.amber,
    Colors.yellow
  ];
  Random random = new Random();
  int index = 0;

  void changeColor() {
    if (index == 6) {
      setState(() => index = 0);
    } else {
      setState(() => index = random.nextInt(6));
    }
  }

  late StoryModal _storyModal;

  bool _isAsyncCall = false;
  bool _isbackPop = true;

  Future<void> send() async {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        setState(() {
          _isAsyncCall = true;
          _isbackPop = false;
        });
      });
      _storyModal = StoryModal(
        content: _textEditingController.text,
        postedBy: auth.currentUser!.uid,
        urls: '',
        type: 'text',
        date: DateTime.now().toString(),
      );
      story.doc(auth.currentUser!.uid).set(
          {'UserId': auth.currentUser!.uid, 'Date': DateTime.now().toString()},
          SetOptions(merge: true)).then((value) {
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
          _textEditingController.clear();
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
    } else {
      Flushbar(
        message: "Please type something!",
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.green[500],
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.white,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentColors[index],
      body: WillPopScope(
        onWillPop: () async => _isbackPop,
        child: ModalProgressHUD(
          child: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                          maxLines: 4,
                          minLines: 1,
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).accentColor,
                          ),
                          controller: _textEditingController,
                          focusNode: _textFieldFocusNode,
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          textInputAction: TextInputAction.go,
                          cursorColor: Theme.of(context).accentColor,
                          keyboardAppearance: Brightness.dark,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          onSubmitted: (_) {}),
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                        color: Colors.black,
                        padding: const EdgeInsets.all(0),
                        child: Icon(Icons.colorize_rounded,
                            size: 30, color: Colors.white),
                        onPressed: () => changeColor(),
                      ),
                    ))
              ],
            ),
          ),
          inAsyncCall: _isAsyncCall,
          progressIndicator: LoadingCustom(
            radius: 40,
          ),
          opacity: 0.3,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check, size: 30, color: Colors.white),
        onPressed: () => send(),
      ),
    );
  }
}
