import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_chat/Widgets/page_header.dart';
import 'package:connect_chat/Widgets/page_profile_image.dart';
import 'package:connect_chat/models/ChatData.dart';
import 'package:connect_chat/models/user_model.dart';
import 'package:connect_chat/pages/profile/profile.dart';
import 'package:connect_chat/providers/chat.dart';
import 'package:connect_chat/providers/user_provider.dart';
import 'package:connect_chat/services/auth_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../chat_screen/chat_screen.dart';
import '../chats/widget/chat_item.dart';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final AuthFirebase _authFirebase = AuthFirebase();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<UserData> _userList = <UserData>[];
  String? query = "";
  final SearchBarController<UserData> _searchBarController =
      SearchBarController();
  bool isReplay = false;

  String? getGroupId(BuildContext context, String contact) {
    String groupId;
    final userId =
        Provider.of<UserProvider>(context, listen: false).getUser!.userId;
    if (userId.hashCode <= contact.hashCode)
      groupId = '$userId-$contact';
    else
      groupId = '$contact-$userId';
    return groupId;
  }

  Future<List<UserData>> _getAllUserList(String? text) async {
    if (text!.length == 2) throw Error();
    if (text.length == 6) return [];
    final List<UserData> posts = text.isEmpty
        ? []
        // ignore: unnecessary_null_comparison
        : _userList != null
            ? _userList.where((UserData userData) {
                String _getUsername = userData.username!.toLowerCase();
                String _query = text.toLowerCase();
                String _getName = userData.username!.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                bool matchesName = _getName.contains(_query);
                return (matchesUsername || matchesName);
              }).toList()
            : [];
    return posts;
  }

  @override
  void initState() {
    super.initState();
    _authFirebase.fetchAllUsers().then((List<UserData> list) {
      setState(() {
        _userList = list;
      });
    });
  }

  void onpressed(BuildContext context, UserData item) {
    final userId =
        Provider.of<UserProvider>(context, listen: false).getUser!.userId;
    // Checks if user has already interacted with peer
    // if has interacted pass chats object otherwise pass an empty one
    final initData =
        Provider.of<Chat>(context, listen: false).chats.firstWhere((element) {
      return element.peer.userId == item.userId;
    }, orElse: () {
      return new ChatData(
        groupId: getGroupId(context, item.userId!),
        userId: userId,
        peerId: item.userId,
        messages: [],
        peer: item,
      );
    });
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: ChatScreen(
              chatData: initData,
            )));
  }

  buildSuggestions(String query) {
    final List<UserData> suggestionList;
    if (query.isEmpty) {
      // ignore: unnecessary_null_comparison
      suggestionList = _userList != null
          ? _userList.where((UserData userData) {
              String _getName = userData.username!.toLowerCase();
              String _query = query.toLowerCase();
              bool matchesName = _getName.contains(_query);
              bool matchesUsername = _getName.contains(_query);
              return (matchesUsername || matchesName);
            }).toList()
          : [];
    } else {
      // ignore: unnecessary_null_comparison
      suggestionList = _userList != null
          ? _userList.where((UserData userData) {
              String _getName = userData.username!.toLowerCase();
              String _query = query.toLowerCase();
              bool matchesName = _getName.contains(_query);
              bool matchesUsername = _getName.contains(_query);
              return (matchesUsername || matchesName);
            }).toList()
          : [];
    }

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: ((context, index) {
          UserData? userInfo = UserData(
              username: suggestionList[index].username,
              email: suggestionList[index].email,
              userId: suggestionList[index].userId,
              img: suggestionList[index].img,
              description: suggestionList[index].description,
              timeCreated: suggestionList[index].timeCreated,
              status: suggestionList[index].status);
          return new ChatItemList(
              receiver: userInfo,
              userName: userInfo.username!,
              subtitle: SizedBox(
                child: Text(
                  userInfo.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              imageUrl: userInfo.img,
              conversationId: userInfo.userId,
              onpressed: onpressed);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: [],
        backgroundColor: Colors.transparent,
        toolbarHeight: 70.0,
        elevation: 0,
        title: CustomPageHeader(
          title: "People",
          suffixWidget: PageProfileImage(
            imageUrl: context.watch<UserProvider>().getUser!.img,
            size: 40.0,
            onlineColor: Color(0xFF4bd8a4),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ProfilePage()));
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SearchBar<UserData>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          textStyle: TextStyle(color: Theme.of(context).accentColor),
          icon: Icon(
            Icons.search,
            color: Theme.of(context).accentColor,
          ),
          onSearch: _getAllUserList,
          searchBarController: _searchBarController,
          onError: (error) => Text('ERROR: ${error.toString()}'),
          placeHolder: buildSuggestions(query!),
          hintText: 'Search',
          cancellationWidget: Text(
            "Cancel",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          emptyWidget: Center(
              child: Text(
            "Search not found!",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          )),
          onCancelled: () {},
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          onItemFound: (UserData? userData, int index) {
            return new ChatItemList(
                receiver: userData,
                userName: userData!.username,
                subtitle: SizedBox(
                  child: Text(
                    userData.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
                imageUrl: userData.img,
                conversationId: userData.userId,
                onpressed: onpressed);
          },
        ),
      ),
    );
  }
}
