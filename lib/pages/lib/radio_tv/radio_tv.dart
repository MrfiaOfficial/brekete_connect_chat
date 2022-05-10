import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:group_chat_app/pages/lib/radio_tv/Radios.dart';
import 'package:group_chat_app/utils/routes.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RadioTV extends StatefulWidget {
  @override
  _RadioTVState createState() => _RadioTVState();
}

class _RadioTVState extends State<RadioTV> {
  @override
  void initState() {
    super.initState();
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
          'TV',
          style: TextStyle(
            color: Color.fromARGB(255, 49, 76, 190),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/streambg.png'),
                    fit: BoxFit.cover)),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RADIO/TV',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 49, 76, 190),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Click stream below to watch us live.',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 400,
                        width: width - 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(11),
                                bottomRight: Radius.circular(11)),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0.5),
                                  spreadRadius: 0.1,
                                  blurRadius: 2,
                                  color: Colors.grey)
                            ]),
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(
                              url: Uri.parse(
                                  'https://player.castr.com/live_26505020d44d11eba40b63345f8bbc51')),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 45,
                            child: ElevatedButton(
                              child: Text("    TV    ",
                                  style: TextStyle(fontSize: 20)),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side:
                                              BorderSide(color: Colors.red)))),
                              onPressed: () async {
                                await canLaunch(
                                        'https://player.castr.com/live_26505020d44d11eba40b63345f8bbc51')
                                    ? await launch(
                                        'https://player.castr.com/live_26505020d44d11eba40b63345f8bbc51')
                                    : throw 'Could not launch ';
                              },
                            ),
                          ),
                          Container(
                            height: 45,
                            child: ElevatedButton(
                              child: Text("   Radio   ",
                                  style: TextStyle(fontSize: 20)),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side:
                                              BorderSide(color: Colors.red)))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Radios()));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
