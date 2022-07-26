import 'package:another_flushbar/flushbar.dart';
import 'package:brekete_connect/chat/Widgets/rounded_loading_button.dart';
import 'package:brekete_connect/chat/pages/tabs/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController = new TextEditingController();
  late TextEditingController passwordController = new TextEditingController();
  late final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future<void> _pressHome() async {
    _btnController.stop();
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Home()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) => _pressHome());
    } on FirebaseAuthException catch (e) {
      _btnController.stop();
      Flushbar(
        message: e.message,
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.black,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Welcome to",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1C1C1C),
            height: 2,
          ),
        ),
        Text(
          "FAMILY CONNECT",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1C),
            letterSpacing: 2,
            height: 1,
          ),
        ),
        Text(
          "Please login to continue",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1C1C1C),
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: emailController,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.black12,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: passwordController,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.black12,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        new Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: RoundedLoadingButton(
            color: Color(0xFF1C1C1C),
            child: Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            controller: _btnController,
            onPressed: () async {
              if (emailController.text == '') {
                _btnController.stop();
                Flushbar(
                  message: 'Please email is required',
                  icon: Icon(
                    Icons.error_outline,
                    size: 28.0,
                    color: Colors.white,
                  ),
                  duration: Duration(seconds: 5),
                  leftBarIndicatorColor: Colors.black,
                )..show(context);
              } else if (passwordController.text == '') {
                _btnController.stop();
                Flushbar(
                  message: 'Please password is required',
                  icon: Icon(
                    Icons.error_outline,
                    size: 28.0,
                    color: Colors.white,
                  ),
                  duration: Duration(seconds: 5),
                  leftBarIndicatorColor: Colors.black,
                )..show(context);
              } else {
                _login();
              }
            },
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "FORGOT PASSWORD?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1C),
            height: 1,
          ),
        ),
      ],
    );
  }
}
