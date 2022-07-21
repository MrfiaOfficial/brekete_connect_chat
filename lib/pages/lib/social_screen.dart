import 'package:brekete_connect/just_added/custom_elevated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brekete_connect/just_added/login_register_page.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/pages/lib/appointment/booked_appointment.dart';
import 'package:brekete_connect/utils/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  var nowUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    String _userLoggedIn = CurrentAppUser.currentUserData.userId;
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
            'Social Media Links',
            style: TextStyle(
              color: Color.fromARGB(255, 49, 76, 190),
            ),
          ),
        ),
        body: Container(
          //height: height,
          //width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/newsbg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //FACEBOOK
                  CustomElevatedButton(
                    onPressed: () {
                      _launchFacebookBF();
                    },
                    socialIcon: FontAwesomeIcons.facebook,
                    text: 'Brekete Family',
                    bgColor: Colors.blueAccent,
                    textColor: Colors.white,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      _launchFacebookHR();
                    },
                    socialIcon: FontAwesomeIcons.facebook,
                    text: 'Human Rights Radio/TV',
                    bgColor: Colors.blueAccent,
                    textColor: Colors.white,
                  ),

                  //INSTAGRAM
                  CustomElevatedButton(
                    onPressed: () {
                      _launchInstagramBF();
                    },
                    socialIcon: FontAwesomeIcons.instagram,
                    text: 'Brekete Family',
                    bgColor: Colors.deepPurple,
                    textColor: Colors.white,
                  ),

                  //TWITTER
                  CustomElevatedButton(
                    onPressed: () {
                      _launchTwitterBF();
                    },
                    socialIcon: FontAwesomeIcons.twitter,
                    text: 'Brekete Family',
                    bgColor: Colors.lightBlue,
                    textColor: Colors.white,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      _launchTwitterHR();
                    },
                    socialIcon: FontAwesomeIcons.twitter,
                    text: 'Human Rights Radio/TV',
                    bgColor: Colors.lightBlue,
                    textColor: Colors.white,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      _launchTwitterOP();
                    },
                    socialIcon: FontAwesomeIcons.twitter,
                    text: 'Ordinary President',
                    bgColor: Colors.lightBlue,
                    textColor: Colors.white,
                  ),

                  //YOUTUBE
                  CustomElevatedButton(
                    onPressed: () {
                      _launchYoutubeBF();
                    },
                    socialIcon: FontAwesomeIcons.youtube,
                    text: 'Brekete Family',
                    bgColor: Colors.red,
                    textColor: Colors.white,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      _launchYoutubeHR();
                    },
                    socialIcon: FontAwesomeIcons.youtube,
                    text: 'Human Rights Radio/TV',
                    bgColor: Colors.red,
                    textColor: Colors.white,
                  ),

                  //TELEGRAM
                  CustomElevatedButton(
                    onPressed: () {
                      _launchTelegramBF();
                    },
                    socialIcon: FontAwesomeIcons.telegram,
                    text: 'Brekete Family',
                    bgColor: Colors.blue,
                    textColor: Colors.white,
                  ),

                  //TIKTOK
                  CustomElevatedButton(
                    onPressed: () {
                      _launchTiktokBF();
                    },
                    socialIcon: FontAwesomeIcons.tiktok,
                    text: 'Brekete Family',
                    bgColor: Colors.black,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchFacebookBF() async {
    if (!await launch('https://www.facebook.com/BreketeFamily/'))
      throw 'Could not launch the link';
  }

  void _launchFacebookHR() async {
    if (!await launch('https://www.facebook.com/hrradiotv/'))
      throw 'Could not launch the link';
  }

  //
  void _launchTwitterBF() async {
    if (!await launch(
        'https://twitter.com/breketeConnect?t=4nNzOGcJ4gwEyxrXwLLVNg&s=09'))
      throw 'Could not launch the link';
  }

  void _launchTwitterHR() async {
    if (!await launch(
        'https://twitter.com/hrightsradiotv?t=eCy_E4Xpl3RvkEKHECJSYw&s=09'))
      throw 'Could not launch the link';
  }

  void _launchTwitterOP() async {
    if (!await launch(
        'https://twitter.com/OrdinaryGcon?t=SIGV-uxdib7WFsYTSPZrXQ&s=09'))
      throw 'Could not launch the link';
  }

  //
  void _launchYoutubeBF() async {
    if (!await launch('https://youtube.com/c/BreketeFamily'))
      throw 'Could not launch the link';
  }

  void _launchYoutubeHR() async {
    if (!await launch('https://youtube.com/c/HRRadioTV'))
      throw 'Could not launch the link';
  }

  //
  void _launchInstagramBF() async {
    if (!await launch(
        'https://instagram.com/breketefamily?igshid=YmMyMTA2M2Y='))
      throw 'Could not launch the link';
  }

  //
  void _launchTelegramBF() async {
    if (!await launch('https://t.me/breketefamilyradio'))
      throw 'Could not launch the link';
  }

  //
  void _launchTiktokBF() async {
    if (!await launch('https://vm.tiktok.com/ZML3UErAU/'))
      throw 'Could not launch the link';
  }
}
