import 'package:flutter/material.dart';
import 'package:brekete_connect/utils/routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class News extends StatefulWidget {
  @override
  createState() => _NewsState();
}

class _NewsState extends State<News> {
  bool isLoading = true;
  final _key = UniqueKey();

  _NewsState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: _scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              AppRoutes.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black)),
        title: Text(
          ' ',
          style: TextStyle(
            color: Color.fromARGB(255, 49, 76, 190),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WebView(
              key: _key,
              initialUrl: 'https://breketefamily.com/blog/',
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }
}
