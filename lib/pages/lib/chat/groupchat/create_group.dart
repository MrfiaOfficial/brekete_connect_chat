import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/models/user_model.dart';
import 'package:brekete_connect/pages/lib/chat/groupchat/add_members.dart';
import 'package:brekete_connect/pages/lib/chat/groupchat/gchat_screen.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  double height;
  double width;
  TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    group = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text('Create Group'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: width * 0.2,
              child: ElevatedButton(
                  child: FittedBox(
                      child:
                          Text("Add Members", style: TextStyle(fontSize: 13))),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(5)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      // backgroundColor:
                      //     MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => const AddMembers());
                    setState(() {});
                  }),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: width * 0.9,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    child: TextFormField(
                      controller: _nameController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      decoration: new InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.blueAccent,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 10, bottom: 2, top: 11, right: 15),
                          hintText: "Enter Group Name"),
                    ),
                  ),
                  SizedBox(height: 10),
                  group.isNotEmpty
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('uid', whereIn: group)
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Text('Something went wrong!');
                            }
                            if (!snapshot.hasData) {
                              return const Text("No Data Found");
                            }
                            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                docList = snapshot.data.docs;
                            List<AppUser> users = [];
                            docList.forEach((element) {
                              AppUser u = AppUser.fromMap(element.data());
                              users.add(u);
                            });

                            return Column(
                                children:
                                    users.map((e) => userCard(e)).toList());
                          })
                      : Container(),
                  SizedBox(height: 5),
                  SizedBox(
                    width: width * 0.75,
                    child: ElevatedButton(
                        child: FittedBox(
                            child: Text(
                          "Create group",
                        )),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        onPressed: () {
                          if (_nameController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'Please Enter Group Name');
                          } else if (group.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'Please Selection at least 1 member');
                          } else {
                            group.add(CurrentAppUser.currentUserData.userId);
                            DocumentReference<Map<String, dynamic>> curDoc =
                                FirebaseFirestore.instance
                                    .collection('groupchat')
                                    .doc();
                            String curDocId = curDoc.id;
                            curDoc.set({
                              'id': curDocId,
                              'name': _nameController.text,
                              'created_by':
                                  CurrentAppUser.currentUserData.userId,
                              'created_at': Timestamp.now(),
                              'members': group,
                              'last_message': 'No Conversation yet',
                              'last_message_by':
                                  CurrentAppUser.currentUserData.userId,
                              'last_message_time': Timestamp.now()
                            });
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => GroupChatScreen(
                                          currentuser:
                                              CurrentAppUser.currentUserData,
                                        )));
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox userCard(AppUser user) {
    return SizedBox(
      width: width * 0.9,
      child: StatefulBuilder(builder: (context, mystate) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 18,
                          child: Icon(Icons.account_circle,
                              size: 36, color: Colors.white)),
                    ),
                    SizedBox(
                        width: width * 0.4,
                        child: Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(width: width * 0.25)
                    // SizedBox(
                    //     child: InkWell(
                    //         onTap: () {
                    //           mystate(() {
                    //             group.add(user.userId);
                    //           });
                    //         },
                    //         child: !group.contains(user.userId)
                    //             ? Card(
                    //                 color: Colors.lightBlue,
                    //                 shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                 ),
                    //                 child: Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Text(
                    //                       'Add to Group',
                    //                       style: TextStyle(fontSize: 10),
                    //                     )))
                    //             : Card(
                    //                 color: Colors.lightGreen,
                    //                 shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                 ),
                    //                 child: Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Text(
                    //                       'Added',
                    //                       style: TextStyle(
                    //                         fontSize: 10,
                    //                       ),
                    //                     )))))
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

List<String> group = [];
