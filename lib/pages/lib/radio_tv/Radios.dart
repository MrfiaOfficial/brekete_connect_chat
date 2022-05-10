import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:group_chat_app/utils/routes.dart';
import 'dart:async';

// import 'package:flutter_radio_player/flutter_radio_player.dart';
// import 'package:group_chat_app/utils/routes.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:flutter_radio/flutter_radio.dart';

class Radios extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Radios> {
  String url = "https://humanrig.radioca.st/stream?type=http&nocache=887";
  bool isPlaying;
  bool isLoading;
  @override
  void initState() {
    // isPlaying=false;
    // isLoading=true;
    // _flutterRadioPlayer.init("Flutter Radio Example", "Live", "https://player.castr.com/live_26505020d44d11eba40b63345f8bbc51", "true").then((value){
    isLoading = false;
    isPlaying = true;
    //   setState(() {});
    // });
    super.initState();
    audioStart();
  }

  Future<void> audioStart() async {
    print('Audio Start OK');
  }

  // FlutterRadioPlayer _flutterRadioPlayer = new FlutterRadioPlayer();

  @override
  void dispose() {
    // _flutterRadioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                AppRoutes.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.black)),
          title: Text(
            'New Complaint',
            style: TextStyle(
              color: Color.fromARGB(255, 49, 76, 190),
            ),
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/streambg.png'),
                        fit: BoxFit.cover)),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RADIO',
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
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: width - 60,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '101.1 FM',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
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
                                              'https://humanrig.radioca.st//stream?type=http&nocache=68')),
                                    )),
                                ElevatedButton(
                                  child: Text('LISTEN',
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white)),
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
                                              side: BorderSide(
                                                  color: Colors.red)))),
                                  onPressed: () async {
                                    await canLaunch(
                                            'https://player.castr.com/live_26505020d44d11eba40b63345f8bbc51?onlyAudio=true')
                                        ? await launch(
                                            'https://player.castr.com/live_26505020d44d11eba40b63345f8bbc51?onlyAudio=true')
                                        : throw 'Could not launch ';
                                    // if(isPlaying){
                                    //   await _flutterRadioPlayer.pause();
                                    //   setState(() {
                                    //     isPlaying=false;
                                    //   });
                                    // }else{
                                    //   await _flutterRadioPlayer.play();
                                    //   setState(() {
                                    //     isPlaying=true;
                                    //   });
                                    // }
                                  },
                                ),
                              ],
                            )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
