import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Streams extends StatefulWidget {
  const Streams({Key key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Streams> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.blueGrey.shade200,
        dialogBackgroundColor: Colors.blueGrey.shade200,
      ),
      home: Scaffold(
        body:WebView(
          initialUrl: 'https://player.castr.com/live_26505020d44d11eba40b63345f8bbc51',
        ),

        /*Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/streambg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              children: [
                SizedBox(height: height*0.1,),
                Row(
                  children: [
                    Text(
                      'LIVE STREAM',
                      style: TextStyle(
                        color: Color.fromARGB(255, 49, 76, 190),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height*0.02,
                ),
                Row(
                  children: [
                    Text(
                      'Click stream below to watch us live',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height*0.03,),
                Container(
                    height: height*0.45,
                  width: width*0.8,

                  child: Card(
                    elevation: 5,
                    child: SingleChildScrollView(
                      child: WebView(
                        initialUrl: 'https://google.com',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height*0.03,),
                Container(
                  height: height*0.06,
                  child: ElevatedButton(
                      child: Text(
                          "STREAM",
                          style: TextStyle(fontSize: 20)
                      ),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                      onPressed: () => null
                  ),
                ),

              ],
            ),
          ),
        ),*/
      ),
    );
  }
}
