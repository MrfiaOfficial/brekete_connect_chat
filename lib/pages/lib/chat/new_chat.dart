import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/models/user_model.dart';
import 'package:group_chat_app/pages/lib/chat/chatting_screen.dart';
import 'package:group_chat_app/pages/lib/chat/message.dart';

class NewChat extends StatefulWidget {
  const NewChat({Key key}) : super(key: key);

  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  double height;
  double width;
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 35,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(7)),
            child: TextField(
              controller: _searchController,
              onChanged: (a) {
                setState(() {});
              },
              decoration: InputDecoration(
                  hintText: " Search",
                  contentPadding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.redAccent,
                    onPressed: () {},
                  )),
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: width * 0.9,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Text('Something went wrong!');
                    }
                    if (!snapshot.hasData) {
                      return const Text("No Data Found");
                    }
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> docList =
                        snapshot.data.docs;
                    List<AppUser> allUsers = [];
                    docList.forEach((element) {
                      AppUser u = AppUser.fromMap(element.data());
                      allUsers.add(u);
                    });

                    return Column(
                        children: allUsers.map((e) {
                      return ((_searchController.text.isEmpty) ||
                              e.name.toLowerCase().contains(
                                  _searchController.text.toLowerCase()))
                          ? Container(
                              margin: const EdgeInsets.only(top: 1, bottom: 1),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: allUsers.indexOf(e) == 0
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))
                                    : allUsers.indexOf(e) ==
                                            snapshot.data.docs.length - 1
                                        ? const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))
                                        : const BorderRadius.all(Radius.zero),
                              ),
                              child: userCard(e))
                          : Container();
                    }).toList());
                  }),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox userCard(AppUser user) {
    return SizedBox(
      width: width * 0.9,
      child: Card(
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
                  SizedBox(
                      child: CurrentAppUser.currentUserData.messages
                              .contains(user.userId)
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChattingScreen(
                                        appUser: user,
                                        currentUser:
                                            CurrentAppUser.currentUserData)));
                              },
                              child: SizedBox(
                                width: width * 0.2,
                                child: Center(
                                  child: Icon(
                                    Icons.message,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                addFriend(user, CurrentAppUser.currentUserData);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChattingScreen(
                                        appUser: user,
                                        currentUser:
                                            CurrentAppUser.currentUserData)));
                              },
                              child: Card(
                                  color: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add, size: 12),
                                        Text(
                                          'Add Freind',
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                  )),
                            ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  addFriend(
    AppUser appUser,
    CurrentAppUser currentUser,
  ) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(appUser.userId)
        .collection(currentUser.userId)
        .add(
          Message(
            ownerId: currentUser.userId,
            message: 'Hi!',
            seen: false,
            createdAt: Timestamp.now().toDate().toIso8601String(),
          ).toMap(),
        );
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.userId)
        .collection(appUser.userId)
        .add(
          Message(
            ownerId: currentUser.userId,
            message: 'Hi!',
            seen: false,
            createdAt: Timestamp.now().toDate().toIso8601String(),
          ).toMap(),
        );
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.userId)
        .update(
      {
        "messages": FieldValue.arrayUnion([appUser.userId]),
      },
    );

    FirebaseFirestore.instance.collection('users').doc(appUser.userId).update(
      {
        "messages": FieldValue.arrayUnion([currentUser.userId]),
      },
    );
    // controller.clear();
  }
}
