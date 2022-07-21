import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/Widgets/rounded_loading_button.dart';
import 'package:brekete_connect/chat/models/user_model.dart';
import 'package:brekete_connect/chat/pages/tabs/home.dart';
import 'package:brekete_connect/chat/services/auth_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController emailController = new TextEditingController();
  late TextEditingController usernameController = new TextEditingController();
  late TextEditingController passwordController = new TextEditingController();
  late final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final AuthFirebase _authMethods = AuthFirebase();

  late UserData _userData;

  Future _pressHome() async {
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Home()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> signUp() async {
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((_) {
        _userData = UserData(
            username: usernameController.text,
            email: emailController.text,
            userId: auth.currentUser!.uid,
            img: '',
            timeCreated: DateTime.now().toString(),
            description: "Hey there! I am using Connect Chat");
        users.doc(_userData.userId).set(_userData.toJson()).then((_) {
          _btnController.stop();
          _pressHome();
        });
        // createUser(_userData);
      });
    } on FirebaseAuthException catch (e) {
      _btnController.stop();
      Flushbar(
        title: "Hi Error ",
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void performGoogleLogin() async {
    _btnController.start();
    UserCredential user = await signInWithGoogle();
    if (user.user != null) {
      authenticateUser(user);
    }
    _btnController.stop();
  }

  void authenticateUser(UserCredential user) {
    _authMethods.authenticateUser(user).then((isNewUser) {
      _btnController.stop();
      if (isNewUser) {
        _userData = UserData(
            username: user.user!.displayName,
            email: user.user!.email,
            userId: user.user!.uid,
            img: user.user!.photoURL,
            timeCreated: DateTime.now().toString(),
            description: "Hey there! I am using Connect Chat");
        users
            .doc(_userData.userId)
            .set(_userData.toJson())
            .then((value) => _pressHome());
      } else {
        _pressHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Sign up with",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            height: 2,
          ),
        ),
        Text(
          "CONNECT CHAT",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: 'Enter Username',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.white24,
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
            fillColor: Colors.grey.withOpacity(0.2),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Enter Email',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.white24,
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
            fillColor: Colors.grey.withOpacity(0.2),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.white24,
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
            fillColor: Colors.grey.withOpacity(0.2),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        new Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: RoundedLoadingButton(
            color: Colors.black,
            child: Text(
              "SIGN UP",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            controller: _btnController,
            onPressed: () async {
              if (usernameController.text == '') {
                _btnController.stop();
                Flushbar(
                  message: 'Please username is required',
                  icon: Icon(
                    Icons.error_outline,
                    size: 28.0,
                    color: Colors.blue,
                  ),
                  duration: Duration(seconds: 5),
                  leftBarIndicatorColor: Colors.blue,
                )..show(context);
              } else if (passwordController.text == '') {
                _btnController.stop();
                Flushbar(
                  message: 'Please password is required',
                  icon: Icon(
                    Icons.error_outline,
                    size: 28.0,
                    color: Colors.blue,
                  ),
                  duration: Duration(seconds: 5),
                  leftBarIndicatorColor: Colors.blue,
                )..show(context);
              } else if (emailController.text == '') {
                _btnController.stop();
                Flushbar(
                  message: 'Please email is required',
                  icon: Icon(
                    Icons.error_outline,
                    size: 28.0,
                    color: Colors.blue,
                  ),
                  duration: Duration(seconds: 5),
                  leftBarIndicatorColor: Colors.blue,
                )..show(context);
              } else {
                signUp();
              }
            },
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          "Or Signup with",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.facebook,
              size: 32,
              color: Colors.blue,
            ),
            SizedBox(
              width: 24,
            ),
            GestureDetector(
              onTap: () => performGoogleLogin(),
              child: Icon(
                FontAwesomeIcons.google,
                size: 32,
                color: Colors.red,
              ),
            ),
          ],
        )
      ],
    );
  }
}
