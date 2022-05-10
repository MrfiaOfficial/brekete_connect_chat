import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/utils/routes.dart';
import 'package:group_chat_app/widgets/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String userName;
  final String groupName;

  ChatPage({this.groupId, this.userName, this.groupName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    sender: snapshot.data.documents[index].data["sender"],
                    sentByMe: widget.userName ==
                        snapshot.data.documents[index].data["sender"],
                  );
                })
            : Container();
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              AppRoutes.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black)),
        title: Text(
          'Chats',
          style: TextStyle(
            color: Color.fromARGB(255, 49, 76, 190),
          ),
        ),
      ),
      /*   appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),*/
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: height * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 2,
                      child: RaisedButton(
                        onPressed: () {
                          //  Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => chatHomePage()));
                        },
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey[700],
                        ),
                        elevation: 10,
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        radius: 40,
                        child: Icon(Icons.perm_identity_outlined),
                      ),
                    ),
                    Text(widget.groupName,
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              Container(height: height * 0.63, child: _chatMessages()),
              // Container(),
              Container(
                //alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 6,
                  //padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      //Icon(Icons.attach_file, size: 25),
                      //Icon(Icons.emoji_emotions_outlined,size: 25,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: messageEditingController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                hintText: "Send a message ...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                      ),

                      SizedBox(width: 12.0),

                      GestureDetector(
                        onTap: () {
                          _sendMessage();
                        },
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                              child: Icon(Icons.send, color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
