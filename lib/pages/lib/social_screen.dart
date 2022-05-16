import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brekete_connect/just_added/login_register_page.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/pages/lib/appointment/booked_appointment.dart';
import 'package:brekete_connect/utils/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key key}) : super(key: key);

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
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/newsbg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: (height - height * 0.06 - 250) * 0.5,
                  ),
                  Container(
                    height: 45,
                    child: ElevatedButton(
                        child: Text("       Facebook      ",
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
                              side: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _launchFacebook();
                        }),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Container(
                    height: 45,
                    child: ElevatedButton(
                        child: Text("      Instagram       ",
                            style: TextStyle(fontSize: 20)),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(color: Colors.red)))),
                        onPressed: () {
                          _launchInstagram();
                        }),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 45,
                    child: ElevatedButton(
                        child: Text("        Twitter          ",
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
                              side: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _launchTwitter();
                        }),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Container(
                    height: 45,
                    child: ElevatedButton(
                        child: Text("        YouTube        ",
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
                              side: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _launchYoutube();
                        }),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchFacebook() async {
    if (!await launch('https://www.paystack.com/pay/mdonate'))
      throw 'Could not launch https://www.paystack.com/pay/mdonate';
  }

  void _launchInstagram() async {
    if (!await launch('https://www.paystack.com/pay/mdonate'))
      throw 'Could not launch https://www.paystack.com/pay/mdonate';
  }

  void _launchTwitter() async {
    if (!await launch('https://www.paystack.com/pay/mdonate'))
      throw 'Could not launch https://www.paystack.com/pay/mdonate';
  }

  void _launchYoutube() async {
    if (!await launch('https://www.paystack.com/pay/mdonate'))
      throw 'Could not launch https://www.paystack.com/pay/mdonate';
  }

  void _launchTelegramGroup() async {
    if (!await launch('https://www.paystack.com/pay/mdonate'))
      throw 'Could not launch https://www.paystack.com/pay/mdonate';
  }

  void _launchfacebookGroup() async {
    if (!await launch('https://www.paystack.com/pay/mdonate'))
      throw 'Could not launch https://www.paystack.com/pay/mdonate';
  }

  void _launchWhatsAppGroup() async {
    if (!await launch('https://www.paystack.com/pay/mdonate'))
      throw 'Could not launch https://www.paystack.com/pay/mdonate';
  }
}
