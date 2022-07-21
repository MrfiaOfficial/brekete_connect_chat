import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/Widgets/rounded_loading_button.dart';
import 'package:brekete_connect/chat/Widgets/section_header.dart';
import 'package:brekete_connect/chat/enum/user_state.dart';
import 'package:brekete_connect/chat/models/loading.dart';
import 'package:brekete_connect/chat/models/modal_progress_hub.dart';
import 'package:brekete_connect/chat/providers/stop_button_rounded.dart';
import 'package:brekete_connect/chat/providers/user_provider.dart';
import 'package:brekete_connect/chat/services/auth_firebase.dart';
import 'package:brekete_connect/chat/styles/style.dart';
import 'package:brekete_connect/chat/themes/theme.dart';
import 'package:brekete_connect/chat/themes/theme_notifier.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_dialogs/material_dialogs.dart';

import '../../main.dart';
import 'widget/account_setting.dart';
import 'widget/help.dart';
import 'widget/policies.dart';
import 'widget/report.dart';
// import 'widget/story_list.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  late final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  late TextEditingController userNameController = new TextEditingController();
  late final FocusNode myFocusNodeUserName = FocusNode();
  final AuthFirebase authFirebase = AuthFirebase();

  bool isDarkModeEnabled = true;
  bool _isAsyncCall = false;

  final ImagePicker _picker = ImagePicker();
  final String? userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }

  Future<void> signOut() async {
    Dialogs.materialDialog(
        msg: 'Are you sure ? you wanna logOut!',
        title: "Delete",
        color: Theme.of(context).backgroundColor,
        titleStyle: TextStyle(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
        msgStyle: TextStyle(color: Theme.of(context).accentColor),
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () => Navigator.of(context).pop(),
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Theme.of(context).dividerColor),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () async {
              final bool isLoggedOut = await AuthFirebase().signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (isLoggedOut) {
                authFirebase.setUserState(
                  userId: userId,
                  userState: UserState.Offline,
                );
                prefs.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            text: 'LogOut',
            iconData: Icons.exit_to_app,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  Future<void> updateUserName() {
    return users
        .doc(userId)
        .update({'Username': userNameController.text}).then((_) {
      Provider.of<UserProvider>(context, listen: false).refreshUser();
    }).catchError((error) {
      Flushbar(
        message: error.message,
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    });
  }

  Future<void> updateProfileImage(dataUrl) {
    return users.doc(userId).update({
      'img': dataUrl,
    }).then((_) {
      setState(() async {
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        userProvider.refreshUser();
        _isAsyncCall = false;
      });
    }).catchError((error) {
      setState(() {
        _isAsyncCall = false;
      });
      Flushbar(
        message: "Something going wrong.",
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    });
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('Images/').child(userId!);
    try {
      await ref.putFile(file).then((_) {
        ref.getDownloadURL().then((fileURL) {
          updateProfileImage(fileURL);
        });
      });
    } on firebase_core.FirebaseException catch (e) {
      setState(() {
        _isAsyncCall = false;
      });
      Flushbar(
        message: e.message,
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    }
  }

  Future<void> themesinit(BuildContext context) async {
    FlutterStatusbarcolor.setStatusBarColor(Theme.of(context).backgroundColor);
    FlutterStatusbarcolor.setNavigationBarColor(
        Theme.of(context).backgroundColor);
    context.watch<ThemeNotifier>().getTheme() == darkTheme
        ? FlutterStatusbarcolor.setStatusBarWhiteForeground(true)
        : FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  }

  // @override
  Widget build(BuildContext context) {
    themesinit(context);
    isDarkModeEnabled =
        (context.watch<ThemeNotifier>().getTheme() == darkTheme);
    _imgFromCamera() async {
      final pickedFile = await _picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        // _image = File(pickedFile.path);
        // Navigator.of(context).pop();
        setState(() {
          _isAsyncCall = true;
        });
        uploadFile(pickedFile.path);
      } else {
        setState(() {
          _isAsyncCall = false;
        });
        Navigator.of(context).pop();
        Flushbar(
          message: 'No image selected.',
          icon: Icon(
            Icons.error_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 5),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }
    }

    _imgFromGallery() async {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // _image = File(pickedFile.path);
        Navigator.of(context).pop();
        setState(() {
          _isAsyncCall = true;
        });
        uploadFile(pickedFile.path);
      } else {
        setState(() {
          _isAsyncCall = false;
        });
        Navigator.of(context).pop();
        Flushbar(
          message: 'No image selected.',
          icon: Icon(
            Icons.error_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 5),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }
    }

    // Show the option of Chooice the camera
    void _imagePicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          _imgFromGallery();
                          // Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera();
                        // Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    //this handel fro the action bottom pop up button
    void _showSheetSignUp() {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0))),
        backgroundColor: Theme.of(context).backgroundColor,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: _formKey,
              child: new Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    new SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: new Container(
                        height: 8.00,
                        width: 60.00,
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          border: Border.all(
                            width: 1.00,
                            color: Theme.of(context).accentColor,
                          ),
                          borderRadius: BorderRadius.circular(4.00),
                        ),
                      ),
                    ),
                    new Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Center(
                          child: Text(
                        "Change UserName",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.teko(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            letterSpacing: 1,
                            fontSize: 20,
                          ),
                        ),
                      )),
                    ),
                    new Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      decoration: kBoxDecorationStyles,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: TextFormField(
                          autofocus: false,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontFamily: "OpenSans"),
                          focusNode: myFocusNodeUserName,
                          controller: userNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "username",
                              hintStyle: TextStyle(
                                color: Theme.of(context).accentColor,
                              )),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Username is required';
                            }
                          },
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 10.0,
                    ),
                    RoundedLoadingButton(
                      color: Color(0xFF4bd8a4),
                      child:
                          Text('Update', style: TextStyle(color: Colors.white)),
                      controller: context
                          .watch<StopAndStartButtonRounded>()
                          .btnController,
                      onPressed: () async {
                        final formState = _formKey.currentState;
                        if (formState!.validate()) {
                          formState.save();
                          updateUserName().then((_) {
                            context
                                .read<StopAndStartButtonRounded>()
                                .roundedButtonStop();
                            userNameController.clear();
                            Navigator.of(context).pop();
                          });
                        } else {
                          context
                              .read<StopAndStartButtonRounded>()
                              .roundedButtonStop();
                        }
                      },
                    ),
                  ]),
            ),
          );
        },
      );
    }

    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.normal,
                  color: Theme.of(context).accentColor,
                  letterSpacing: 0)),
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 70.0,
        elevation: 0,
      ),
      body: ModalProgressHUD(
        child: SafeArea(
          child: SingleChildScrollView(
            child: new Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: new Stack(
                            fit: StackFit.loose,
                            children: <Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                      child: new Container(
                                        width: 140.0,
                                        height: 140.0,
                                        child: ClipOval(
                                          child: profileImageUrl(),
                                        ),
                                      ),
                                      onTap: () {}),
                                ],
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 90.0, right: 100.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          _imagePicker(context);
                                        },
                                        child: new CircleAvatar(
                                          backgroundColor: Colors.black26,
                                          radius: 20.0,
                                          child: new Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Text(
                          context.watch<UserProvider>().getUser!.username!,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.normal,
                                  color: Theme.of(context).accentColor,
                                  letterSpacing: 0)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ListTile(
                    title: Text(
                      "Dark Mode",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Transform.scale(
                        scale: 0.6,
                        child: Container(
                            child: DayNightSwitcher(
                                isDarkModeEnabled: isDarkModeEnabled,
                                onStateChanged: onStateChanged))),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        child: DayNightSwitcherIcon(
                          isDarkModeEnabled: isDarkModeEnabled,
                          onStateChanged: onStateChanged,
                        ),
                        margin: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Username",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () => _showSheetSignUp(),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        color: Colors.blue[500],
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: ExactAssetImage("assets/images/account.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SectionHeader(
                    title: "Account",
                    textColor: Theme.of(context).dividerColor,
                    textSize: 15,
                  ),
                  ListTile(
                    title: Text("Account Settings",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold)),
                    onTap: () => Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: AccountSetting())),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        color: Colors.red[400],
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image:
                                ExactAssetImage("assets/images/settings.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("Report a problem",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold)),
                    onTap: () => Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: ReportProblem())),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        color: Colors.red[100],
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: ExactAssetImage("assets/images/report.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Help",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade, child: Help())),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        color: Colors.blue[400],
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: ExactAssetImage("assets/images/help.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Legal & Policies",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade, child: Policies())),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: ExactAssetImage("assets/images/legal.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "LogOut",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () => signOut(),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: ExactAssetImage("assets/images/logout.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        inAsyncCall: _isAsyncCall,
        progressIndicator: LoadingCustom(
          radius: 40,
        ),
        opacity: 0.3,
      ),
    );
  }

  Widget profileImageUrl() {
    if (context.watch<UserProvider>().getUser!.img == null) {
      return Image.asset(
        'assets/images/account.png',
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: CachedNetworkImageProvider(
            context.watch<UserProvider>().getUser!.img!),
        fit: BoxFit.cover,
      );
    }
  }

  void onThemeChanged(bool value) async {
    (value)
        ? context.read<ThemeNotifier>().setTheme(darkTheme)
        : context.read<ThemeNotifier>().setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  void onStateChanged(bool isDarkModeEnabled) {
    setState(() {
      this.isDarkModeEnabled = isDarkModeEnabled;
    });
    onThemeChanged(isDarkModeEnabled);
  }
}
