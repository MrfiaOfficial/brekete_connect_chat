import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/utils/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  File image;
  @override
  void initState() {
    _name.text = CurrentAppUser.currentUserData.name;
    _email.text = CurrentAppUser.currentUserData.email;
    _phone.text = CurrentAppUser.currentUserData.phone;
    _address.text = CurrentAppUser.currentUserData.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.blueGrey.shade200,
        dialogBackgroundColor: Colors.blueGrey.shade200,
      ),
      home: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          /* appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
                onTap: () {
                  AppRoutes.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                color: Color.fromARGB(255, 49, 76, 190),
              ),
            ),
          ), */
          body: Stack(
            children: [
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/chatsbg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: height * .225,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.07,
                            ),
                            InkWell(
                                onTap: () async {
                                  File img = await pickImage();
                                  if (img != null) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    String url = await updateUserImage(
                                        CurrentAppUser.currentUserData.userId,
                                        img);

                                    if (url != null) {
                                      await uploadUserImage(url);
                                      Fluttertoast.showToast(
                                          msg:
                                              'Profile Picture updated successfully');
                                    }

                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                child:
                                    CurrentAppUser.currentUserData.photo == ""
                                        ? Icon(
                                            Icons.account_circle_rounded,
                                            color: Colors.white,
                                            size: 90.0,
                                          )
                                        : Container(
                                            height: 75,
                                            width: 75,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                imageUrl: CurrentAppUser
                                                    .currentUserData.photo,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Container(
                          height: height * 0.65,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      fieldView(
                                          'Name',
                                          CurrentAppUser.currentUserData.name,
                                          false,
                                          _name),
                                      SizedBox(
                                        height: height * 0.025,
                                      ),
                                      fieldView(
                                          'Email',
                                          CurrentAppUser.currentUserData.email,
                                          true,
                                          _email),
                                      SizedBox(
                                        height: height * 0.025,
                                      ),
                                      fieldView(
                                          'Phone Number',
                                          CurrentAppUser.currentUserData.phone,
                                          false,
                                          _phone),
                                      SizedBox(
                                        height: height * 0.025,
                                      ),
                                      fieldView(
                                          'Address',
                                          CurrentAppUser
                                              .currentUserData.address,
                                          false,
                                          _address),
                                      SizedBox(
                                        height: height * 0.025,
                                      ),
                                      Container(
                                        height: height * 0.04,
                                        width: width * 0.35,
                                        child: ElevatedButton(
                                          child: Text("Update",
                                              style: TextStyle(fontSize: 18)),
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<Color>(
                                                      Colors.white),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      side: BorderSide(color: Colors.red)))),
                                          onPressed: () async {
                                            if (_name.text !=
                                                CurrentAppUser
                                                    .currentUserData.name) {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(CurrentAppUser
                                                      .currentUserData.userId)
                                                  .update(
                                                      {'username': _name.text});
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Username updated Successfully!');
                                              Navigator.pop(context);
                                            }
                                            if (_phone.text !=
                                                CurrentAppUser
                                                    .currentUserData.phone) {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(CurrentAppUser
                                                      .currentUserData.userId)
                                                  .update(
                                                      {'phone': _phone.text});
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Phone Number updated Successfully!');
                                              Navigator.pop(context);
                                            }
                                            if (_address.text !=
                                                CurrentAppUser
                                                    .currentUserData.address) {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(CurrentAppUser
                                                      .currentUserData.userId)
                                                  .update({
                                                'address': _address.text
                                              });
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Address updated Successfully!');
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.015,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 5),
                    child: IconButton(
                      onPressed: () {
                        AppRoutes.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldView(String title, String value, bool readOnly,
      TextEditingController _controller) {
    return TextFormField(
      controller: _controller,
      readOnly: readOnly,
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: '$title'),
    );
  }

  Future<File> pickImage() async {
    final img = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720,
        imageQuality: 60);
    if (img == null) return null;

    image = File(img.path);
    return image;
  }

  static Future<String> updateUserImage(String userId, File image) async {
    try {
      TaskSnapshot task = await FirebaseStorage.instance
          .ref('images/${userId.toString()}.png')
          .putFile(image);
      String url = await task.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
        msg: 'Error ${e.code}: ${e.message}',
        gravity: ToastGravity.BOTTOM,
      );
      return null;
    }
  }

  static Future<bool> uploadUserImage(dynamic value) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CurrentAppUser.currentUserData.userId)
          .update(
        {
          'profilePic': value,
        },
      );
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unexpected Error, Something went wrong' + e);
      print(e);
      return false;
    }
  }
}
