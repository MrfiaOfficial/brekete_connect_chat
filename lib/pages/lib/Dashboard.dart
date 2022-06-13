import 'package:brekete_connect/pages/lib/mediation/mediation_screen.dart';
import 'package:brekete_connect/pages/lib/social_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brekete_connect/helper/helper_functions.dart';
import 'package:brekete_connect/just_added/login_register_page.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/pages/lib/News.dart';
import 'package:brekete_connect/pages/lib/appointment/appointment_screen.dart';
import 'package:brekete_connect/pages/lib/complaints/complaint_screen.dart';
import 'package:brekete_connect/pages/lib/donate/donate1.dart';
import 'package:brekete_connect/pages/lib/profile/Chats.dart';
import 'package:brekete_connect/pages/lib/profile/user_profile.dart';
import 'package:brekete_connect/pages/lib/radio_tv/radio_tv.dart';
import 'package:brekete_connect/shop/home.dart';
import 'package:brekete_connect/shop/pages/HomePage.dart';
import 'package:brekete_connect/utils/routes.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Meditation.dart';
import 'complaint/Conplaint.dart';
import 'donate/Donate.dart';

import 'Signin.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var nowUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    CurrentAppUser.currentUserData.getUserData().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    String _userLoggedIn = CurrentAppUser.currentUserData.userId;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.blueGrey.shade200,
        dialogBackgroundColor: Colors.blueGrey.shade200,
      ),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/dashboardbg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  height: height * .15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: height * 0.06,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'Home',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        //onTap: _userLoggedIn
                        //onTap: CurrentAppUser.currentUserData.userId != null
                        onTap: nowUser != null
                            ? () {
                                //AppRoutes.push(context, MyProfile());
                                AppRoutes.push(context, Chats());
                              }
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UnAuthScreen(),
                                  ),
                                );
                              },
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Icon(
                                Icons.account_circle_rounded,
                                color: Colors.white,
                                size: 60.0,
                              ),
                              /* child: CurrentAppUser.currentUserData.photo == ""
                                  ? Icon(
                                      Icons.account_circle_rounded,
                                      color: Colors.white,
                                      size: 60.0,
                                    )
                                  : Container(
                                      height: 50,
                                      width: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          imageUrl: CurrentAppUser
                                              .currentUserData.photo,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ), */
                            ),
                            // SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * .85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            //onTap: CurrentAppUser.currentUserData.userId == ""
                            //onTap: _userLoggedIn
                            //onTap: CurrentAppUser.currentUserData.userId != null
                            onTap: nowUser != null
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Chats(),
                                      ),
                                    );
                                  }
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UnAuthScreen(),
                                        //builder: (context) => Chats(),
                                      ),
                                    );
                                  },
                            child: NeumorphicContainer(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Image.asset(
                                    'assets/logicon.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Text(
                                    '         FAMILY        ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '         NETWORK        ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  /* Text(
                                    '         FAMILY \nNETWORK         ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ), */
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ComplaintScreen(),
                                  ));
                            },
                            child: NeumorphicContainer(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Image.asset(
                                    'assets/complaint.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  Text(
                                    '      LAY YOUR      ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '     COMPLAINT      ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppointmentScreen(),
                                ),
                              );
                            },
                            child: NeumorphicContainer(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Image.asset(
                                    'assets/book.png',
                                    height: 60,
                                    width: 60,
                                  ),
                                  SizedBox(
                                    height: height * 0.005,
                                  ),
                                  Text(
                                    '              BOOK              ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '     APPOINTMENT        ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.005,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RadioTV()));
                            },
                            child: NeumorphicContainer(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Image.asset(
                                    'assets/tv.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                  Text(
                                    '       TV/RADIO          ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: nowUser != null
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MediationScreen()));
                                  }
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UnAuthScreen(),
                                      ),
                                    );
                                  },
                            child: NeumorphicContainer(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Image.asset(
                                    'assets/meditation.png',
                                    height: 45,
                                    width: 45,
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    '      REQUEST FOR      ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'MEDIATION',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SocialScreen()));

                              // Fluttertoast.showToast(
                              //     msg: 'Feature under development!');
                            },
                            child: NeumorphicContainer(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Image.asset(
                                    'assets/chat.png',
                                    height: 60,
                                    width: 60,
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    '           SOCIAL            ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /* InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homes()));

                              // Fluttertoast.showToast(
                              //     msg: 'Feature under development!');
                            },
                            child: NeumorphicContainer(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Image.asset(
                                    'assets/shop.png',
                                    height: 60,
                                    width: 60,
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    '           SHOP            ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                ],
                              ),
                            ),
                          ), */
                        ],
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /* InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => News()));

                              // Fluttertoast.showToast(
                              //     msg: 'Feature under development!');
                            },
                            child: NeumorphicContainer(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Image.asset(
                                    'assets/news.png',
                                    height: 60,
                                    width: 60,
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    '            NEWS             ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                ],
                              ),
                            ),
                          ), */
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Donate1()));
                            },
                            child: NeumorphicContainer(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Image.asset(
                                    'assets/donate.png',
                                    height: 60,
                                    width: 60,
                                  ),
                                  Text(
                                    '         DONATE          ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 49, 76, 190),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ), /* add child content here */
        ),
      ),
    );
  }

  void _launchURL() async {
    if (!await launch('https://breketeconnect.com.ng'))
      throw 'Could not launch https://breketeconnect.com.ng';
  }
}

class NeumorphicContainer extends StatefulWidget {
  final Widget child;
  final double bevel;
  final Offset blurOffset;
  final Color color;

  NeumorphicContainer({
    Key key,
    this.child,
    this.bevel = 10.0,
    this.color,
  })  : this.blurOffset = Offset(bevel / 2, bevel / 2),
        super(key: key);

  @override
  _NeumorphicContainerState createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = this.widget.color ?? Theme.of(context).backgroundColor;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _isPressed ? color : color.mix(Colors.black, .1),
                _isPressed ? color.mix(Colors.black, .10) : color,
                _isPressed ? color.mix(Colors.black, .10) : color,
                color.mix(Colors.white, _isPressed ? .2 : .5),
              ],
              stops: [
                0.0,
                .3,
                .6,
                1.0,
              ]),
          boxShadow: _isPressed
              ? null
              : [
                  BoxShadow(
                    blurRadius: widget.bevel,
                    offset: -widget.blurOffset,
                    color: color.mix(Colors.white, .6),
                  ),
                  BoxShadow(
                    blurRadius: widget.bevel,
                    offset: widget.blurOffset,
                    color: color.mix(Colors.black, .3),
                  )
                ],
        ),
        child: widget.child,
      ),
    );
  }
}

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount);
  }
}
