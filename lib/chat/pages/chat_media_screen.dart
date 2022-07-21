import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brekete_connect/chat/services/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'tabs/chat_screen/widget/app_bar.dart';

class ChatMediaScreen extends StatefulWidget {
  final String? groupId;
  ChatMediaScreen(this.groupId);
  @override
  _ChatMediaScreenState createState() => _ChatMediaScreenState();
}

class _ChatMediaScreenState extends State<ChatMediaScreen> {
  late DB db;

  @override
  void initState() {
    super.initState();
    db = DB();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            leading: CBackButton(),
            centerTitle: true,
            title: Text(
              'Chat Media',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).accentColor.withOpacity(0.87),
              ),
            ),
          ),
        ),
        body: StreamBuilder(
          stream: db.getChatMediaStream(widget.groupId),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CupertinoActivityIndicator());
            else if (snapshot.data!.docs.length == 0)
              return Center(
                  child: Text(
                'No media avaialable.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).accentColor,
                ),
              ));
            else {
              var documents = snapshot.data!.docs;
              return GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 15),
                itemCount: documents.length,
                itemBuilder: (ctx, i) => SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.network(
                    documents[i]['url'],
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, progress) {
                      return progress != null
                          ? Center(child: CupertinoActivityIndicator())
                          : child;
                    },
                  ),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
