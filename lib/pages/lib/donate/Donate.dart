import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:brekete_connect/utils/routes.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Donate extends StatefulWidget {
  const Donate({Key key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Donate> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            'Donate',
            style: TextStyle(
              color: Color.fromARGB(255, 49, 76, 190),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/newsbg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 80),
                  child: WebView(
                    initialUrl: 'https://www.paystack.com/pay/mdonate',
                    onWebResourceError: (WebResourceError e) {
                      Fluttertoast.showToast(msg: 'Could not open page! $e');
                    },
                  ),
                )),
            Container(
              color: Colors.red,
              height: 80,
              width: width,
              padding: EdgeInsets.all(10),
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
