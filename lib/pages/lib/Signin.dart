import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Dashboard.dart';
import 'SignUp.dart';


class Signin extends StatelessWidget {
  const Signin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/backg.png'),fit:BoxFit.cover
              )
          ),
          child: Column(
            children: [
              Container(height: height*0.15),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Container(
                    height: height*0.65,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height*0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                        "Login",
                                        style: TextStyle(fontSize: 14)
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18.0),
                                              side: BorderSide(color: Colors.red)
                                          )
                                      )
                                  ),
                                  onPressed: () => null
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => SignUp()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Text("Signup",style: TextStyle(
                                      color: Colors.red
                                  ),),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: SizedBox(
                              height :height*0.05,
                              child: TextFormField(
                                //controller: _phoneController,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Colors.black
                                ),
                                decoration: new InputDecoration(


                                    hintStyle: TextStyle(
                                      color: Colors.orangeAccent,

                                    ),
                                    contentPadding:
                                    EdgeInsets.only(left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Enter Username Or Email"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: SizedBox(
                              height :height*0.05,
                              child: TextFormField(
                                //controller: _phoneController,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Colors.black
                                ),
                                decoration: new InputDecoration(


                                    hintStyle: TextStyle(
                                      color: Colors.orangeAccent,

                                    ),
                                    contentPadding:
                                    EdgeInsets.only(left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Password"),
                              ),
                            ),
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20,top: 20),
                                child: Text("Forgot Password",style: TextStyle(
                                  color: Colors.red,
                                ),),
                              )
                            ],),
                          SizedBox(
                            height: height*0.06,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) => Dashboard()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                    "Login",
                                    style: TextStyle(fontSize: 24)
                                ),
                              ),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)
                                      )
                                  )
                              ),

                          ),
                          SizedBox(
                            height: height*0.03,
                          ),
                          Text("OR",style: TextStyle(
                              color: Colors.black12,
                              fontSize: 28
                          ),),
                          SizedBox(
                            height: height*0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Fluttertoast.showToast(msg: 'Login with facebook failed!');
                                },child: Image.asset("assets/facebook.png",height: 70,width:70 ,)),
                              SizedBox(
                                width: 25,
                              ),
                              GestureDetector(
                                onTap: (){
                                  Fluttertoast.showToast(msg: 'Login failed!');
                                },child: Image.asset("images/google.png",height: 70,width:70 ,)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
