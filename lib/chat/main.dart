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

import 'providers/chat.dart';

void main() async {
  //FirebaseAnalytics(); was used before
  FirebaseAnalytics;
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  await Firebase.initializeApp();
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

class MyApp extends StatelessWidget {
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
        title: 'Connect Chat',
        theme: context.watch<ThemeNotifier>().getTheme(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/profile':
              return PageTransition(
                  child: ProfilePage(), type: PageTransitionType.bottomToTop);
              // ignore: dead_code
              break;
            default:
              return null;
          }
        },
        home: App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late UserProvider userProvider;

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool? userMethod;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        FirebaseAuth.instance.authStateChanges().listen((user) {
          if (user == null) {
            // print('User is currently signed out!');
            userMethod = false;
          } else {
            // print('User is signed in!');
            userMethod = true;
          }
        });
        if (snapshot.connectionState == ConnectionState.done) {
          if (userMethod == true) {
            return Home();
          } else if (userMethod == false) {
            return LoginPage();
          }
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool login = true;

  Future<void> themesinit(BuildContext context) async {
    FlutterStatusbarcolor.setStatusBarColor(Theme.of(context).backgroundColor);
    FlutterStatusbarcolor.setNavigationBarColor(
        Theme.of(context).backgroundColor);
    context.watch<ThemeNotifier>().getTheme() == darkTheme
        ? FlutterStatusbarcolor.setStatusBarWhiteForeground(true)
        : FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  }

  @override
  Widget build(BuildContext context) {
    themesinit(context);
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  login = true;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
                height: login
                    ? MediaQuery.of(context).size.height * 0.6
                    : MediaQuery.of(context).size.height * 0.4,
                child: CustomPaint(
                  painter: CurvePainter(login),
                  child: Container(
                    padding: EdgeInsets.only(bottom: login ? 0 : 55),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          child: login ? Login() : LoginOption(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  login = false;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
                height: login
                    ? MediaQuery.of(context).size.height * 0.4
                    : MediaQuery.of(context).size.height * 0.6,
                child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(top: login ? 55 : 0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          child: !login ? SignUp() : SignUpOption(),
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  bool outterCurve;
  CurvePainter(this.outterCurve);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width * 0.5,
        outterCurve ? size.height + 110 : size.height - 110,
        size.width,
        size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
