import 'package:connect_chat/database/repository/log_repository.dart';
import 'package:connect_chat/enum/user_state.dart';
import 'package:connect_chat/pages/callScreen/pickup/pickup_layout.dart';
import 'package:connect_chat/pages/tabs/calls/call.dart';
import 'package:connect_chat/pages/tabs/chats/chats_conversation.dart';
import 'package:connect_chat/pages/tabs/people/people.dart';
import 'package:connect_chat/providers/chat.dart';
import 'package:connect_chat/providers/user_provider.dart';
import 'package:connect_chat/services/auth_firebase.dart';
import 'package:connect_chat/themes/theme.dart';
import 'package:connect_chat/themes/theme_notifier.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'stories/stories.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int _currentIndex = 0;
  List<Widget>? _widgetOptions;
  late UserProvider userProvider;
  final AuthFirebase _authFirebase = AuthFirebase();
  bool isLoading = true;
  bool initLoaded = true;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUser();
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.refreshUser();
      _authFirebase.setUserState(
        userId: userProvider.getUser!.userId!,
        userState: UserState.Online,
      );
    });
    // Fetch user data(chats and contacts), and update online status
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Chat>(context, listen: false)
          .getUserDetailsAndContacts()
          .then((value) {
        if (value) {
          Provider.of<Chat>(context, listen: false).fetchChats();
        } else {
          Provider.of<Chat>(context, listen: false).clear();
        }
      });
    }).then((value) => setState(() => initLoaded = true));

    LogRepository.init(
      isHive: true,
      dbName: auth.currentUser!.uid,
    );

    WidgetsBinding.instance!.addObserver(this);

    _widgetOptions = [ChatPage(), StoriesPage(), PeoplePage(), CallPage()];
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (initLoaded) {
      initLoaded = false;
      isLoading = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String? currentUserId =
        // ignore: unnecessary_null_comparison
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser!.userId
            : "";
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authFirebase.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;

      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authFirebase.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authFirebase.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authFirebase.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
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

  @override
  Widget build(BuildContext context) {
    themesinit(context);
    return PickupLayout(
      scaffold: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Center(
            child: _widgetOptions!.elementAt(_currentIndex),
          ),
          bottomNavigationBar: CustomNavigationBar(
            iconSize: 30.0,
            selectedColor: Theme.of(context).accentColor,
            strokeColor: Color(0xFF4bd8a4),
            unSelectedColor: Color(0xff6c788a),
            backgroundColor: Theme.of(context).backgroundColor,
            items: [
              CustomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.comment),
                title: Text('Chats',
                    style: TextStyle(color: Theme.of(context).accentColor)),
                selectedIcon: Icon(
                  FontAwesomeIcons.comment,
                  color: Color(0xFF4bd8a4),
                ),
                selectedTitle: Text(
                  'Chats',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF4bd8a4)),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.view_carousel),
                selectedIcon: Icon(
                  Icons.view_carousel,
                  color: Color(0xFF4bd8a4),
                ),
                title: Text("Stories",
                    style: TextStyle(color: Theme.of(context).accentColor)),
                selectedTitle: Text(
                  'Stories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4bd8a4),
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.people),
                selectedIcon: Icon(
                  Icons.people,
                  color: Color(0xFF4bd8a4),
                ),
                title: Text("People",
                    style: TextStyle(color: Theme.of(context).accentColor)),
                selectedTitle: Text(
                  'People',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4bd8a4),
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.history),
                title: Text("Calls",
                    style: TextStyle(color: Theme.of(context).accentColor)),
                selectedIcon: Icon(
                  Icons.history,
                  color: Color(0xFF4bd8a4),
                ),
                selectedTitle: Text(
                  'Calls',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4bd8a4),
                  ),
                ),
              ),
            ],
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          )),
    );
  }
}
