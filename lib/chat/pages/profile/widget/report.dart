import 'package:flutter/material.dart';

class ReportProblem extends StatefulWidget {
  ReportProblem({Key? key}) : super(key: key);

  @override
  _ReportProblemState createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: 70.0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
            child: Text(
          "What Happened?",
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        )),
        leading: BackButton(
          color: Theme.of(context).accentColor,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.send,
                color: Theme.of(context).accentColor,
              ))
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
