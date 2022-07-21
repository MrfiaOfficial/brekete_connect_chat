import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:brekete_connect/helper/helper_functions.dart';
import 'package:brekete_connect/utils/routes.dart';
import 'Dashboard.dart';
import 'signin_page.dart';

import 'package:brekete_connect/services/auth_service.dart';
import 'package:brekete_connect/shared/constants.dart';
import 'package:brekete_connect/shared/loading.dart';

class RegisterPage extends StatefulWidget {
  final Function? toggleView;
  RegisterPage({this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool showvalue = false;

  // text field state
  String fullName = '';
  String email = '';
  String password = '';
  String error = '';
  String phone = '';
  String state = '';
  String lga = '';
  String sex = '';
  String username = '';
  String address = '';

  _onRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth
            .registerWithEmailAndPassword(fullName, email, password, state, lga,
                sex, phone, username, address)
            .then((result) async {
          if (result != null) {
            await HelperFunctions.saveUserLoggedInSharedPreference(true);
            await HelperFunctions.saveUserEmailSharedPreference(email);
            await HelperFunctions.saveUserNameSharedPreference(fullName);
            Fluttertoast.showToast(msg: 'Registered Successfully!');
            AppRoutes.makeFirst(context, Dashboard());
            print("Registered");
          } else {
            Fluttertoast.showToast(msg: 'Registration failed!');
            setState(() {
              error = 'Error while registering the user!';
              _isLoading = false;
            });
          }
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Registration failed! $e');
        setState(() {
          error = 'Error while registering the user$e!';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return _isLoading
        ? Loading()
        : Scaffold(
            /* appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(
                  onTap: () {
                    AppRoutes.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.black)),
              title: Text(
                'Register',
                style: TextStyle(
                  color: Color.fromARGB(255, 49, 76, 190),
                ),
              ),
            ), */
            body: Stack(children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/Signupbg.png'),
                            fit: BoxFit.cover)),
                    child: Column(
                      children: [
                        Container(height: height * 0.15),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                          child: Container(
                            //height: height * 0.78,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          SignInPage()));
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
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () => null,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: height * 0.45,
                                    child: ListView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: SizedBox(
                                            // height :height*0.05,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: new InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 0,
                                                          bottom: 2,
                                                          top: 11,
                                                          right: 15),
                                                  hintText: "Full Name"),
                                              onChanged: (val) {
                                                setState(() {
                                                  fullName = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: SizedBox(
                                            // height :height*0.05,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: new InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 0,
                                                          bottom: 2,
                                                          top: 11,
                                                          right: 15),
                                                  hintText: "Email Address"),
                                              validator: (val) {
                                                return RegExp(
                                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                        .hasMatch(val!)
                                                    ? null
                                                    : "Please enter a valid email";
                                              },
                                              onChanged: (val) {
                                                setState(() {
                                                  email = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: SizedBox(
                                            // height :height*0.05,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: new InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 0,
                                                          bottom: 2,
                                                          top: 11,
                                                          right: 15),
                                                  hintText: "Address"),
                                              onChanged: (val) {
                                                setState(() {
                                                  address = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: SizedBox(
                                            // height :height*0.05,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: new InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 0,
                                                          bottom: 2,
                                                          top: 11,
                                                          right: 15),
                                                  hintText: "Username"),
                                              onChanged: (val) {
                                                setState(() {
                                                  username = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: SizedBox(
                                            // height :height*0.05,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: new InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 0,
                                                          bottom: 2,
                                                          top: 11,
                                                          right: 15),
                                                  hintText: "Password"),
                                              validator: (val) => val!.length <
                                                      6
                                                  ? 'Password not strong enough'
                                                  : null,
                                              obscureText: true,
                                              onChanged: (val) {
                                                setState(() {
                                                  password = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: SizedBox(
                                            // // height :height*0.05,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: new InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 0,
                                                          bottom: 2,
                                                          top: 11,
                                                          right: 15),
                                                  hintText: "Confirm Password"),
                                              validator: (val) {
                                                return val != password
                                                    ? 'Password does not match!'
                                                    : null;
                                              },
                                              obscureText: true,
                                              onChanged: (val) {
                                                setState(() {
                                                  // password = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /* SizedBox(
                                    height: height * 0.01,
                                  ), */
                                  // Old RaiseButton
                                  /* Container(
                                    height: height * 0.05,
                                    width: width * 0.4,
                                    child: RaisedButton(
                                        elevation: 0.0,
                                        color: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        child: Text('Signup',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0)),
                                        onPressed: () {
                                          _onRegister();
                                        }),
                                  ), */
                                  Container(
                                    height: height * 0.05,
                                    width: width * 0.4,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red, // background
                                          onPrimary: Colors.white, // foreground
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0)),
                                        ),
                                        child: Text('Signup',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0)),
                                        onPressed: () {
                                          _onRegister();
                                        }),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  /* Text(
                                    "OR",
                                    style: TextStyle(
                                        color: Colors.black12, fontSize: 28),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Login with facebook failed!');
                                          },
                                          child: Image.asset(
                                            "assets/facebook.png",
                                            height: 70,
                                            width: 70,
                                          )),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Fluttertoast.showToast(
                                                msg: 'Login failed!');
                                          },
                                          child: Image.asset(
                                            "images/google.png",
                                            height: 70,
                                            width: 70,
                                          )),
                                    ],
                                  ), */
                                  SizedBox(
                                    height: height * 0.03,
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
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 5),
                    child: IconButton(
                      onPressed: () {
                        AppRoutes.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    )),
              ),
            ]),
          );
  }
}
