import 'package:another_flushbar/flushbar.dart';
import 'package:brekete_connect/chat/Widgets/rounded_loading_button.dart';
import 'package:brekete_connect/chat/providers/stop_button_rounded.dart';
import 'package:brekete_connect/chat/providers/user_provider.dart';
import 'package:brekete_connect/chat/styles/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountSetting extends StatefulWidget {
  AccountSetting({Key? key}) : super(key: key);

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  late final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  late final FocusNode myFocusNodeEmail = FocusNode();
  late final FocusNode myFocusNodePassword = FocusNode();
  late final FocusNode newFocusNodePassword = FocusNode();

  late TextEditingController newEmailController = new TextEditingController();
  late TextEditingController newPasswordController =
      new TextEditingController();
  late TextEditingController currentPasswordController =
      new TextEditingController();

  void updateEmail({String? newEmail}) async {
    final user = FirebaseAuth.instance.currentUser;
    user!.updateEmail(newEmail!).then((_) {
      context.read<StopAndStartButtonRounded>().roundedButtonStop();
      newEmailController.clear();
      Navigator.of(context).pop();
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: 'Updated successfully',
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    }).catchError((onError) {
      context.read<StopAndStartButtonRounded>().roundedButtonStop();
    });
  }

  void changeUpdatePassword(
      {String? currentPassword, String? newPassword}) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword!);

    user.reauthenticateWithCredential(cred).then((_) {
      user.updatePassword(newPassword!).then((_) {
        context.read<StopAndStartButtonRounded>().roundedButtonStop();
        newPasswordController.clear();
        currentPasswordController.clear();
        Navigator.of(context).pop();
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          message: 'Updated successfully',
          icon: Icon(
            Icons.error_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 5),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }).catchError((onError) {
        context.read<StopAndStartButtonRounded>().roundedButtonStop();
      });
    }).catchError((onError) {
      context.read<StopAndStartButtonRounded>().roundedButtonStop();
      Flushbar(
        message: 'the credential is not correct',
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

  @override
  Widget build(BuildContext context) {
    void _updatePassword() {
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
                            color: Color(0xffb5b2b2),
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
                        "Change Password",
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
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      decoration: kBoxDecorationStyles,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: TextFormField(
                          autofocus: false,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontFamily: "OpenSans"),
                          focusNode: myFocusNodePassword,
                          controller: currentPasswordController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Password is required';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Current Password',
                            hintStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      decoration: kBoxDecorationStyles,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: TextFormField(
                          autofocus: false,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontFamily: "OpenSans"),
                          focusNode: newFocusNodePassword,
                          controller: newPasswordController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Password is required';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            hintStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 10.0,
                    ),
                    RoundedLoadingButton(
                      color: Color(0xFF4bd8a4),
                      child: Text('Update Password',
                          style: TextStyle(color: Colors.white)),
                      controller: context
                          .watch<StopAndStartButtonRounded>()
                          .btnController,
                      onPressed: () async {
                        final formState = _formKey.currentState;
                        if (formState!.validate()) {
                          formState.save();
                          changeUpdatePassword(
                              currentPassword: currentPasswordController.text,
                              newPassword:
                                  newPasswordController.text.toString());
                          context.read<UserProvider>().refreshUser();
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

    void _updateEmail() {
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
                            color: Color(0xffb5b2b2),
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
                        "Change Email",
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
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      decoration: kBoxDecorationStyles,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: TextFormField(
                            autofocus: false,
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontFamily: "OpenSans"),
                            focusNode: myFocusNodePassword,
                            controller: newEmailController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*")
                                  .hasMatch(val)) {
                                return 'Enter a valid new email address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'New Email',
                              hintStyle: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress),
                      ),
                    ),
                    new SizedBox(
                      height: 10.0,
                    ),
                    RoundedLoadingButton(
                      color: Color(0xFF4bd8a4),
                      child: Text('Update Email',
                          style: TextStyle(color: Colors.white)),
                      controller: context
                          .watch<StopAndStartButtonRounded>()
                          .btnController,
                      onPressed: () async {
                        final formState = _formKey.currentState;
                        if (formState!.validate()) {
                          formState.save();
                          updateEmail(newEmail: newEmailController.text);
                          context.read<UserProvider>().refreshUser();
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
      backgroundColor: Theme.of(context).backgroundColor,
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        toolbarHeight: 70.0,
        elevation: 0,
        leading: BackButton(
          color: Theme.of(context).accentColor,
        ),
        title: Text('Setting',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () async {
                _updatePassword();
              },
              leading: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    color: Theme.of(context).accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock,
                    color: Theme.of(context).dividerColor,
                  )),
              title: Text(
                "Change Password",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "It's a good to use a strong password that your not using elsewhere",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 13),
              ),
            ),
            ListTile(
              leading: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    color: Theme.of(context).accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.password_rounded,
                    color: Theme.of(context).dividerColor,
                  )),
              title: Text(
                "Use tow-factor authentication",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "We'll ask login code if we notice an attempted login from an unrecognized device or brower.",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 13),
              ),
            ),
            ListTile(
              onTap: _updateEmail,
              leading: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    color: Theme.of(context).accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.email,
                    color: Theme.of(context).dividerColor,
                  )),
              title: Text(
                "Change Email Address",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    color: Theme.of(context).accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.block,
                    color: Theme.of(context).dividerColor,
                  )),
              title: Text(
                "Blocking",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
