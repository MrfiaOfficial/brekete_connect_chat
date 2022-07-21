import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:flutter/material.dart';
import 'package:brekete_connect/helper/helper_functions.dart';
import 'SearchGroup.dart';
import 'package:brekete_connect/services/auth_service.dart';
import 'package:brekete_connect/services/database_service.dart';
import 'package:brekete_connect/widgets/group_tile.dart';

class GroupChat extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<GroupChat> {
  // data
  final AuthService _auth = AuthService();
  late FA.User _user;
  late String _groupName;
  String _userName = '';
  String _email = '';
  late Stream _groups;

  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  // widgets
  Widget noGroupWidget() {
    return Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/bg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  SearchPage();
                },
                child: Icon(Icons.add_circle, color: Colors.amber, size: 75.0)),
            SizedBox(height: 20.0),
            Text(
                "You've not joined any group, tap on the 'add' icon to search a group."),
          ],
        ));
  }

  Widget groupsList() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder<dynamic>(
      stream: _groups,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            // print(snapshot.data['groups'].length);
            if (snapshot.data['groups'].length != 0) {
              return Container(
                height: height,
                width: width,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('assets/newsbg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: height * 0.15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 13, right: 13, top: 5, bottom: 5),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.arrow_back,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 1, right: 9, top: 5),
                                child: Center(
                                  child: Text(
                                    "Group Chat",
                                    style: TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 1, right: 9, top: 5),
                                child: Center(
                                  child: Text(
                                    "       ",
                                    style: TextStyle(
                                      fontSize: 27,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Icon(Icons.search),
                                ),
                                Text(
                                  "Search Group",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Icon(Icons.filter_alt_sharp),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchPage()));
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.75,
                      child: ListView.builder(
                          itemCount: snapshot.data['groups'].length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            int reqIndex =
                                snapshot.data['groups'].length - index - 1;
                            return GroupTile(
                                userName: snapshot.data['fullName'],
                                groupId: _destructureId(
                                    snapshot.data['groups'][reqIndex]),
                                groupName: _destructureName(
                                    snapshot.data['groups'][reqIndex]));
                          }),
                    ),
                  ],
                ),
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // functions
  _getUserAuthAndJoinedGroups() async {
    _user = (await FA.FirebaseAuth.instance.currentUser)!;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
  }

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  void _popupDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(
            context, MaterialPageRoute(builder: (context) => GroupChat()));
      },
    );
    Widget createButton = TextButton(
      child: Text("Create"),
      onPressed: () async {
        if (_groupName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            DatabaseService(uid: _user.uid).createGroup(val, _groupName);
          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: SingleChildScrollView(
        child: TextField(
            onChanged: (val) {
              _groupName = val;
            },
            style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
      ),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: groupsList(),
    );
  }
}
