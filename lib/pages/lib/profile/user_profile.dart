import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/utils/routes.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.blueGrey.shade200,
        dialogBackgroundColor: Colors.blueGrey.shade200,
      ),
      home: Scaffold(
        /* appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                AppRoutes.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.black)),
          title: Text(
            'My Profile',
            style: TextStyle(
              color: Color.fromARGB(255, 49, 76, 190),
            ),
          ),
        ), */
        body: Stack(
          children: [
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/chatsbg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: height * .225,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.07,
                        ),
                        CurrentAppUser.currentUserData.photo == ""
                            ? Icon(
                                Icons.account_circle_rounded,
                                color: Colors.white,
                                size: 90.0,
                              )
                            : Container(
                                height: 75,
                                width: 75,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        CurrentAppUser.currentUserData.photo,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Container(
                      height: height * 0.65,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  fieldView('Name',
                                      CurrentAppUser.currentUserData.name),
                                  SizedBox(
                                    height: height * 0.025,
                                  ),
                                  fieldView('Email',
                                      CurrentAppUser.currentUserData.email),
                                  SizedBox(
                                    height: height * 0.025,
                                  ),
                                  fieldView('Phone Number',
                                      CurrentAppUser.currentUserData.phone),
                                  SizedBox(
                                    height: height * 0.025,
                                  ),
                                  fieldView('Address',
                                      CurrentAppUser.currentUserData.address),
                                  SizedBox(
                                    height: height * 0.025,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 10, 5),
                  child: IconButton(
                    onPressed: () {
                      AppRoutes.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget fieldView(String title, String value) {
    return TextFormField(
      controller: TextEditingController(text: '$value'),
      readOnly: true,
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: '$title'),
    );
  }
}
