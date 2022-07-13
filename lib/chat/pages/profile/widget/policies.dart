import 'package:flutter/material.dart';

class Policies extends StatefulWidget {
  Policies({Key? key}) : super(key: key);

  @override
  _PoliciesState createState() => _PoliciesState();
}

class _PoliciesState extends State<Policies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 70.0,
        elevation: 0,
        title: Text(
          "Legal & Policies",
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        leading: BackButton(
          color: Theme.of(context).accentColor,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "Terms of Service",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text(
                  "Data Policy",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text(
                  "Cookies Policy",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text(
                  "Third-Party Notice",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
