import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/utils/routes.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SubmittedComplaint extends StatefulWidget {
  @override
  _SubmittedComplaintState createState() => _SubmittedComplaintState();
}

class _SubmittedComplaintState extends State<SubmittedComplaint> {
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MaterialApp(
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
            'Complaints',
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
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Submitted_Complaints')
                      .where('creater_id',
                          isEqualTo: CurrentAppUser.currentUserData.userId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    return new ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return Card(
                          child: new ListTile(
                            title: new Text(data['case_type'],
                                style: TextStyle(color: Colors.blue)),
                            // subtitle: Icon(Icons.download, color: Colors.blue,),

                            trailing: GestureDetector(
                                onTap: () {
                                  AppRoutes.push(context, ViewFile());
                                },
                                child: Icon(
                                  Icons.view_agenda,
                                  color: Colors.blue,
                                )),
                          ),
                        );
                      }).toList(),
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}

class ViewFile extends StatefulWidget {
  @override
  _ViewFileState createState() => _ViewFileState();
}

class _ViewFileState extends State<ViewFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Image.file(
        File(
            '/data/user/0/com.ittechnologix.bereketeconnect/cache/image_picker866478834184422166.jpg')
        // loadingWidget: CircularProgressIndicator(),
      ),
    );
  }
}
