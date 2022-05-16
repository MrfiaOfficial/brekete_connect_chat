import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brekete_connect/utils/routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class News extends StatefulWidget {
  const News({Key key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<News> {
  double progress = 0;
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
            'News',
            style: TextStyle(
              color: Color.fromARGB(255, 49, 76, 190),
            ),
          ),
        ), */
        body: Stack(
          children: [
            Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/newsbg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: WebView(
                  initialUrl: 'https://breketeconnect.com.ng/',
                  //initialUrl: 'https://savadub.com/',
                )),
            Container(
              color: Colors.red,
              height: 100,
              width: width,
              padding: EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {
                  AppRoutes.pop(context);
                },
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
