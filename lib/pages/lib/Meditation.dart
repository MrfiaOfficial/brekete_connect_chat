import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/shop/constants/app_color.dart';
import 'package:group_chat_app/shop/constants/text_styles.dart';
import 'package:group_chat_app/shop/utils/custom_button.dart';
import 'package:group_chat_app/utils/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class Meditation extends StatefulWidget {
  const Meditation({Key key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Meditation> {
  bool checked;
  List<File> files = [];
  bool isLoading;

  @override
  void initState() {
    checked = false;
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.blueGrey.shade200,
        dialogBackgroundColor: Colors.blueGrey.shade200,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                AppRoutes.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.black)),
          title: Text(
            'Meditation',
            style: TextStyle(
              color: Color.fromARGB(255, 49, 76, 190),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'REQUEST FOR MEDITATION',
                      style: TextStyle(
                        color: Color.fromARGB(255, 49, 76, 190),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'By clicking on the download below you have accepted the terms and conditions of the Ordinary President.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 49, 76, 190),
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: checked,
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            onChanged: (v) {
                              checked = v;
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'I ACCEPT TERMS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 49, 76, 190),
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      height: height * 0.08,
                      // width: width*0.,
                      child: ElevatedButton(
                        child: Text("DOWNLOAD", style: TextStyle(fontSize: 24)),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.red)))),
                        onPressed: () async {
                          File file = await getFileFromAssets();
                          fileDownloadedPopup(context, width, file: file);
                          Fluttertoast.showToast(msg: 'File downloaded!');
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50,
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
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                    // borderRadius: BorderRadius.circular(12.0),
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
                      height: 30,
                    ),
                    Container(
                      height: height * 0.08,
                      // width: width*0.,
                      child: ElevatedButton(
                        child: Text("    Upload    ",
                            style: TextStyle(fontSize: 24)),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.red)))),
                        onPressed: () async {
                          if (checked) {
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
                          } else {
                            Fluttertoast.showToast(
                                msg: 'You need to accept terms!');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> get _localPath async {
    Directory directory;
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        directory = await getExternalStorageDirectory();
        String newPath = "";
        print(directory);
        List<String> paths = directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/Brekete Family";
        directory = Directory(newPath);
      } else {
        Fluttertoast.showToast(msg: 'Permission denied!');
        return null;
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        directory = await getTemporaryDirectory();
      } else {
        Fluttertoast.showToast(msg: 'Permission denied!');
        return null;
      }
    }
    if (!(await directory.exists())) {
      await directory.create();
    }
    File saveFile = File(directory.path + "/Brekete Family Mediation Form.pdf");
    if (!(await saveFile.exists())) {
      await saveFile.create();
    }
    return saveFile.path;
  }

  Future<File> getFileFromAssets() async {
    final byteData =
        await rootBundle.load('assets/Brekete_Family_meditation_form.pdf');
    final path = await _localPath;
    final file = File('$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
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
        // "sender": widget.userName,
        // 'time': DateTime.now().millisecondsSinceEpoch,
      };
      await FirebaseFirestore.instance
          .collection('meditations')
          .doc()
          .set(chatMessageMap);

      //DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {});
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

  Future<void> fileDownloadedPopup(BuildContext context1, double width,
      {File file}) async {
    return showDialog<void>(
      context: context1,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.185,
                    ),
                    Text(
                      'File downloaded',
                      style: AppTextStyles.mediumText
                          .copyWith(color: Colors.black),
                    ),
                    const Expanded(child: SizedBox()),
                    TextButton(
                      child: Icon(
                        Icons.close,
                        size: 18,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'Your file has been downloaded path ${file.path}',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton.myButton(
                  'OK',
                  () {
                    Navigator.pop(context);
                  },
                  Colors.white,
                  width * 0.2,
                  sideborderColor: AppColor.fadeColor,
                  textColor: AppColor.fadeColor,
                ),
                CustomButton.myButton('Open', () async {
                  await OpenFile.open(file.path);
                  // Navigator.pop(context);
                  // Navigator.pop(context1);
                }, Colors.red.withOpacity(0.8), width * 0.2,
                    sideborderColor: Color(0xffDF7878)),
              ],
            ),
          ],
        );
      },
    );
  }
}
