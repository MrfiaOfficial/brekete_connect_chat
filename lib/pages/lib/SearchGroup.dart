import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:flutter/material.dart';
import 'package:brekete_connect/helper/helper_functions.dart';
import 'package:brekete_connect/pages/chat_page.dart';
import 'package:brekete_connect/services/database_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // data
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool hasUserSearched = false;
  bool _isJoined = false;
  String _userName = '';
  FA.User _user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // initState()
  @override
  void initState() {
    super.initState();
    _getCurrentUserNameAndUid();
  }

  // functions
  _getCurrentUserNameAndUid() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      _userName = value;
    });
    _user = FA.FirebaseAuth.instance.currentUser;
  }

  _initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        //print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  void _showScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.blueAccent,
      duration: Duration(milliseconds: 1500),
      content: Text(message,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 17.0)),
    ));
  }

  _joinValueInGroup(
      String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseService(uid: _user.uid)
        .isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }

  // widgets
  Widget groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                _userName,
                searchResultSnapshot.docs[index]["groupId"],
                searchResultSnapshot.docs[index]["groupName"],
                searchResultSnapshot.docs[index]["admin"],
              );
            })
        : Container();
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    _joinValueInGroup(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.blueAccent,
          child: Text(groupName.substring(0, 1).toUpperCase(),
              style: TextStyle(color: Colors.white))),
      title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Admin: $admin"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: _user.uid)
              .togglingGroupJoin(groupId, groupName, userName);
          if (_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });
            // await DatabaseService(uid: _user.uid).userJoinGroup(groupId, groupName, userName);
            _showScaffold('Successfully joined the group "$groupName"');
            Future.delayed(Duration(milliseconds: 2000), () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatPage(
                      groupId: groupId,
                      userName: userName,
                      groupName: groupName)));
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
            });
            _showScaffold('Left the group "$groupName"');
          }
        },
        child: _isJoined
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black87,
                    border: Border.all(color: Colors.white, width: 1.0)),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Joined', style: TextStyle(color: Colors.white)),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blueAccent,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Join', style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }

  // building the search page widget
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      /*appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black87,
        title: Text('Search', style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold, color: Colors.white)),
      ),*/
      body: // isLoading ? Container(
          //   child: Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // )
          // :
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.jpeg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Row(
                  children: [
                    Text(
                      "Search groups to join:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                                hintText: "Search groups...",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              _initiateSearch();
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 254, 184, 28),
                                    borderRadius: BorderRadius.circular(40)),
                                child: Icon(Icons.search, color: Colors.white)))
                      ],
                    ),
                  ),
                ),
              ),
              isLoading
                  ? Container(child: Center(child: CircularProgressIndicator()))
                  : groupList()
            ],
          ),
        ),
      ),
    );
  }
}
