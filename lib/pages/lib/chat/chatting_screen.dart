import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/models/user_model.dart';
import 'package:brekete_connect/pages/lib/chat/message.dart';
import 'package:intl/intl.dart';

class ChattingScreen extends StatelessWidget {
  final AppUser appUser;
  final CurrentAppUser currentUser;
  final String productInfo;

  ChattingScreen({
    Key key,
    @required this.appUser,
    @required this.currentUser,
    this.productInfo,
  }) : super(key: key);

  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            appUser.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: MessageField(
            appUser: appUser, currentUser: currentUser, info: productInfo),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: [
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.userId)
                    .collection(appUser.userId)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<Message> messagesList = [];
                  snapshot.data.docs.forEach((element) {
                    messagesList.add(Message.fromMap(element.data()));
                  });
                  updateStatus(snapshot.data.docs);
                  Future.delayed(Duration(seconds: 1), () {
                    _controller.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: Duration(microseconds: 1),
                      curve: Curves.fastOutSlowIn,
                    );
                  });
                  return messagesList.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text('Start the Conversation'),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 70.0),
                            child: ListView.builder(
                              reverse: true,
                              // controller: _controller,
                              shrinkWrap: true,
                              itemCount: messagesList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MessageTile(
                                    message: messagesList[index],
                                    currentUser: currentUser,
                                    user: appUser);
                              },
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateStatus(List<QueryDocumentSnapshot> docs) async {
    for (int i = 0; i < docs.length; i++) {
      if ((docs[i].data() as Map<String, dynamic>)['ownerId'].toString() !=
          currentUser.userId) print("${docs[i].reference} === > status : true");
      await docs[i].reference.update({'seen': true});
    }
  }
}

class MessageTile extends StatelessWidget {
  final CurrentAppUser currentUser;
  final Message message;
  final AppUser user;
  const MessageTile(
      {Key key,
      @required this.currentUser,
      @required this.message,
      @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: message.ownerId == currentUser.userId
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          // constraints: BoxConstraints(maxWidth: size.width * 0.7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: message.ownerId == currentUser.userId
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              (currentUser.userId != message.ownerId)
                  ? CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.account_circle,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 5),
                      child: Text(
                        DateTime.parse(message.createdAt).day ==
                                Timestamp.now().toDate().day
                            ? DateFormat('hh:mm a ')
                                .format(DateTime.parse(message.createdAt))
                            : DateFormat('dd MMM, hh:mm a  ')
                                .format(DateTime.parse(message.createdAt)),
                        style: TextStyle(
                            fontSize: size.width * 0.03,
                            color: const Color(0xff6B6B6B)),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: message.ownerId == currentUser.userId
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.ownerId == currentUser.userId
                          ? '  ${currentUser.name}'
                          : '  ${user.name}',
                      style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff6B6B6B)),
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffEFEDED)),
                          child: Text(
                            message.message,
                            style: TextStyle(fontSize: size.width * 0.05),
                          ),
                        ),
                        if (currentUser.userId != message.ownerId)
                          Text(
                            DateTime.parse(message.createdAt).day ==
                                    Timestamp.now().toDate().day
                                ? DateFormat(' hh:mm a')
                                    .format(DateTime.parse(message.createdAt))
                                : DateFormat(' dd MMM, hh:mm a')
                                    .format(DateTime.parse(message.createdAt)),
                            style: TextStyle(
                                fontSize: size.width * 0.02,
                                color: const Color(0xff6B6B6B)),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ),
              if (currentUser.userId == message.ownerId)
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.account_circle,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _image(String url) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            //backgroundColor: AppColor.appColor,
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.5, left: 1.5),
            child: Container(
              height: 47,
              width: 47,
              child: CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, imageProvider) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => (SafeArea(
                                child: Scaffold(
                                  backgroundColor: Colors.black,
                                  body: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ))),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Container(
                      child: CircleAvatar(
                        radius: 17,
                        backgroundImage: imageProvider,
                      ),
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageField extends StatelessWidget {
  final AppUser appUser;
  final CurrentAppUser currentUser;
  final TextEditingController controller = TextEditingController();
  final String info;

  MessageField(
      {Key key, @required this.appUser, @required this.currentUser, this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (info != null) {
      controller.text = info;
    }
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        height: size.height * 0.08,
        width: size.width * 0.95,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red, // red as border color
                  ),
                ),
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: controller,
                  expands: true,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12, 8, 0, 8),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const RotationTransition(
                        turns: AlwaysStoppedAnimation(315 / 360),
                        child: Icon(
                          Icons.send,
                          color: Colors.redAccent,
                        ),
                      ),
                      onPressed: () async {
                        if (controller.text.trim().isEmpty) {
                          Fluttertoast.showToast(msg: 'Please write a message');
                        } else {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(appUser.userId)
                              .collection(currentUser.userId)
                              .add(
                                Message(
                                  ownerId: currentUser.userId,
                                  message: controller.text.trim(),
                                  seen: false,
                                  createdAt: Timestamp.now()
                                      .toDate()
                                      .toIso8601String(),
                                ).toMap(),
                              );
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser.userId)
                              .collection(appUser.userId)
                              .add(
                                Message(
                                  ownerId: currentUser.userId,
                                  message: controller.text.trim(),
                                  seen: false,
                                  createdAt: Timestamp.now()
                                      .toDate()
                                      .toIso8601String(),
                                ).toMap(),
                              );
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser.userId)
                              .update(
                            {
                              "messages":
                                  FieldValue.arrayUnion([appUser.userId]),
                            },
                          );

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(appUser.userId)
                              .update(
                            {
                              "messages":
                                  FieldValue.arrayUnion([currentUser.userId]),
                            },
                          );
                          controller.clear();
                        }
                      },
                    ),
                    hintText: "Write Message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
