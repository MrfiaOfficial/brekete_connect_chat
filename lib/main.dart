import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brekete_connect/helper/helper_functions.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/pages/lib/Dashboard.dart';
import 'package:brekete_connect/pages/lib/authenticate_page.dart';

// From Chat Code
import 'package:brekete_connect/chat/pages/loginPage/login.dart';
import 'package:brekete_connect/chat/pages/loginPage/login_option.dart';
import 'package:brekete_connect/chat/pages/profile/profile.dart';
import 'package:brekete_connect/chat/pages/signupPage/signup.dart';
import 'package:brekete_connect/chat/pages/signupPage/signup_option.dart';
import 'package:brekete_connect/chat/pages/tabs/home.dart';
import 'package:brekete_connect/chat/providers/ConnectivityChangeNotifier.dart';
import 'package:brekete_connect/chat/providers/image_upload_provider.dart';
import 'package:brekete_connect/chat/providers/stop_button_rounded.dart';
import 'package:brekete_connect/chat/providers/user_provider.dart';
import 'package:brekete_connect/chat/themes/theme.dart';
import 'package:brekete_connect/chat/themes/theme_notifier.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:brekete_connect/chat/providers/chat.dart';

//void main() => runApp(MyApp());

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAnalytics;

  //runApp(MyApp());
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
    //     .copyWith(statusBarColor: darkModeOn ? Colors.black : Colors.white));
    runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (BuildContext context) {
        return ThemeNotifier(darkModeOn ? darkTheme : lightTheme);
      },
      child: MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    //Firebase.initializeApp();
    super.initState();
    _getUserLoggedInStatus();
  }

  _getUserLoggedInStatus() async {
    //await Firebase.initializeApp();
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if (value != null) {
        setState(() {
          _isLoggedIn = value;
        });
        if (value) {
          CurrentAppUser.currentUserData.getUserData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Chat()),
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StopAndStartButtonRounded()),
        ChangeNotifierProvider(create: (_) {
          ConnectivityChangeNotifier changeNotifier =
              ConnectivityChangeNotifier();
          //Inital load is an async function, can use FutureBuilder to show loading
          //screen while this function running. This is not covered in this tutorial
          changeNotifier.initialLoad();
          return changeNotifier;
        }),
      ],
      child: MaterialApp(
        title: 'Brekete Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),

        //home: _isLoggedIn != null ? _isLoggedIn ? HomePage() : AuthenticatePage() : Center(child: CircularProgressIndicator()),

        home: SplashScreen(),
        /* routes: <String, WidgetBuilder>{
        "login": (BuildContext context) =>
            _isLoggedIn ? Dashboard() : AuthenticatePage(),
        //home: HomePage(),
      }, */
      ),
    );
  }
}

/// Component UI
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  @override

  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 3500), NavigatorPage);
  }

  /// To navigate layout change
  void NavigatorPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }

  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    startTime();
  }

  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(),
      ),
    );
  }
}
