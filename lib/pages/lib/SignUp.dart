import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:brekete_connect/utils/routes.dart';

import 'Signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
          'SignUp',
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
                  image: AssetImage('assets/Signupbg.png'), fit: BoxFit.cover)),
          child: Column(
            children: [
              Container(height: height * 0.15),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Container(
                    height: height * 0.65,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Signin()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text("Signup",
                                        style: TextStyle(fontSize: 14)),
                                  ),
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
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.red)))),
                                  onPressed: () => null),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: SizedBox(
                              height: height * 0.05,
                              child: TextFormField(
                                //controller: _phoneController,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.orangeAccent,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Username"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: SizedBox(
                              height: height * 0.05,
                              child: TextFormField(
                                //controller: _phoneController,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.orangeAccent,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Email Address"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: SizedBox(
                              height: height * 0.05,
                              child: TextFormField(
                                //controller: _phoneController,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.orangeAccent,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Password"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: SizedBox(
                              height: height * 0.05,
                              child: TextFormField(
                                //controller: _phoneController,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.orangeAccent,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Confirm Password"),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.04,
                          ),
                          ElevatedButton(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text("Signup",
                                    style: TextStyle(fontSize: 24)),
                              ),
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
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.red)))),
                              onPressed: () => null),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          // Text("OR",style: TextStyle(
                          //     color: Colors.black12,
                          //     fontSize: 28
                          // ),),
                          // SizedBox(
                          //   height: height*0.015,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: (){
                          //         Fluttertoast.showToast(msg: 'Signup with facebook failed!');
                          //       },
                          //       child: Image.asset("assets/facebook.png",height: 70,width:70 ,)),
                          //     SizedBox(
                          //       width: 25,
                          //     ),
                          //     GestureDetector(
                          //       onTap: (){
                          //         Fluttertoast.showToast(msg: 'Signup failed!');
                          //       },child: Image.asset("images/google.png",height: 70,width:70 ,)),
                          //   ],
                          // ),

                          SizedBox(
                            height: height * 0.01,
                          ),
                          Text(
                            "Powered By 'Brekete Family'",
                            style: TextStyle(
                              color: Colors.red,
                            ),
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
