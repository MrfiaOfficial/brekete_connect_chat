import 'dart:io';
import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/utils/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Meditation.dart';

class Conplaint extends StatefulWidget {
  const Conplaint({Key key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Conplaint> {
  List<String> _case = ['Family', 'Government', 'Corporate'];
  String _selectedcase = 'Family';
  List<File> files = [];
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.blueGrey.shade200,
        dialogBackgroundColor: Colors.blueGrey.shade200,
      ),
      home: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          body: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/newsbg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'COMPLAINT',
                        style: TextStyle(
                          color: Color.fromARGB(255, 49, 76, 190),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'CASE TYPE',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: height * 0.05,
                        width: width * 0.4,
                        decoration: BoxDecoration(
                            color: Color(0XFFEFF3F6),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  offset: Offset(6, 2),
                                  blurRadius: 6.0,
                                  spreadRadius: 3.0),
                              BoxShadow(
                                  color: Color.fromRGBO(255, 255, 255, 0.9),
                                  offset: Offset(-6, -2),
                                  blurRadius: 6.0,
                                  spreadRadius: 3.0)
                            ]),
                        // child: DropdownButtonHideUnderline(
                        // child: ButtonTheme(
                        // alignedDropdown: true,
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              // hint: Text('Place                                                                          '), // Not necessary for Option 1
                              value: _selectedcase,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedcase = newValue;
                                });
                              },
                              items: _case.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Container(
                    height: height * 0.06,
                    width: width * 0.6,
                    child: ElevatedButton(
                      child:
                          Text("Select File", style: TextStyle(fontSize: 20)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: () async {
                        if (await Permission.storage.request().isGranted) {
                          final ImagePicker _picker = ImagePicker();
                          final XFile image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          files.length > 0
                              ? files[0] = File(image.path)
                              : files.add(File(image.path));
                          setState(() {});
                          print('-======================> ${image.path}');
                        } else {
                          Fluttertoast.showToast(msg: 'Permission denied!');
                        }
                      },
                    ),
                  ),
                  files.length < 1
                      ? Container()
                      : Container(
                          child: Text('${files.first.path}'),
                        ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Container(
                    height: height * 0.06,
                    width: width * 0.6,
                    child: ElevatedButton(
                      child: Text("Complaint", style: TextStyle(fontSize: 20)),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String url = await uploadImage(files[0]);
                        if (url != null) {
                          bool res = await _uploadComplaint(url);
                          // Fluttertoast.showToast(msg: 'New Complaint submitted!');
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: height * 0.06,
                    width: width * 0.6,
                    child: ElevatedButton(
                      child: Text("Request for Meditation",
                          style: TextStyle(fontSize: 20)),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Meditation()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> uploadImage(File file) async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = storageReference.putFile(file);
      String url = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      return url;
    } catch (e) {
      Fluttertoast.showToast(msg: "File upload failed! $e");
      return null;
    }
  }

  Future<bool> _uploadComplaint(String url) async {
    try {
      Map<String, dynamic> chatMessageMap = {
        'created_at': Timestamp.now(),
        'creater_id': CurrentAppUser.currentUserData.userId,
        'file_url': url,
        'case_type': _selectedcase
        // "sender": widget.userName,
        // 'time': DateTime.now().millisecondsSinceEpoch,
      };
      await FirebaseFirestore.instance
          .collection('Submitted_Complaints')
          .doc()
          .set(chatMessageMap);

      //DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        // name.text = "";
      });
      Fluttertoast.showToast(
          msg: 'New Complaint Successfully Added!',
          timeInSecForIosWeb: 3,
          gravity: ToastGravity.TOP);
      AppRoutes.pop(context);
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong!');
      return false;
    }
  }
}
