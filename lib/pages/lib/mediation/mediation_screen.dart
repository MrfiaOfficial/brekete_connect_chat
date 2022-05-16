import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brekete_connect/just_added/login_register_page.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/pages/lib/appointment/booked_appointment.dart';
import 'package:brekete_connect/utils/routes.dart';

import 'submit.dart';

class MediationScreen extends StatefulWidget {
  const MediationScreen({Key key}) : super(key: key);

  @override
  _MediationState createState() => _MediationState();
}

class _MediationState extends State<MediationScreen> {
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
            'Appointments',
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
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                      child: Text("BOOK NEW APPOINTMENT",
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
                      onPressed: nowUser != null
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Book()));
                            }
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UnAuthScreen(),
                                ),
                              );
                            },
                    ),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Container(
                    height: 45,
                    child: ElevatedButton(
                      child: Text(" BOOKED  APPOINTMENTS ",
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
                      onPressed: nowUser != null
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookedAppointments()));
                            }
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UnAuthScreen(),
                                ),
                              );
                            },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
