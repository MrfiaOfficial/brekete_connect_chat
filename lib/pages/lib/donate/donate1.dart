import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/utils/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Donate.dart';

class Donate1 extends StatefulWidget {
  const Donate1({Key key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Donate1> {
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
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/newsbg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                Text(
                  'Join us as we put smile on the faces of the less privileged in our Society by donating',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
//                 Row(
//                   children: [
//                     Text(
//                       '''Brekete Family.
// Gtbank
// Naira Account - 0051543571

// Dollar - 0136015865

// Pound - 0136015779

// Euro - 0136015982

// Swift Code- GTBINGLA''',
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         color: Colors.black87,
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
                SizedBox(
                  height: height * 0.25,
                ),
                Container(
                  height: height * 0.08,
                  width: width * 0.6,
                  child: ElevatedButton(
                    child: Text("Donate", style: TextStyle(fontSize: 24)),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(color: Colors.red)))),
                    onPressed: () {
                      _launchURL();
                      // Navigator.push(context, MaterialPageRoute(
                      //     builder: (context) =>
                      //         Donate()
                      // ));
                    },
                  ),
                ),
                // SizedBox(
                //   height: 20.0,
                // ),
                // Image.asset(
                //   'assets/payment.png',
                //   width: width - 50,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL() async {
    if (!await launch('https://www.paystack.com/pay/mdonate'))
      throw 'Could not launch https://www.paystack.com/pay/mdonate';
  }
}
