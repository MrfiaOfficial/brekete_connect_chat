import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/utils/routes.dart';
import 'register_page.dart';

import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/shared/loading.dart';

import 'Dashboard.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool showvalue = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _onSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth
            .signInWithEmailAndPassword(email, password)
            .then((result) async {
          if (result != null) {
            QuerySnapshot userInfoSnapshot =
                await DatabaseService().getUserData(email);

            await HelperFunctions.saveUserLoggedInSharedPreference(true);
            await HelperFunctions.saveUserEmailSharedPreference(email);
            await HelperFunctions.saveUserNameSharedPreference(
                userInfoSnapshot.docs.first['fullName']);

            print("Signed In");
            await HelperFunctions.getUserLoggedInSharedPreference()
                .then((value) {
              print("Logged in: $value");
            });
            await HelperFunctions.getUserEmailSharedPreference().then((value) {
              print("Email: $value");
            });
            await HelperFunctions.getUserNameSharedPreference().then((value) {
              print("Full Name: $value");
            });
            setState(() {
              _isLoading = false;
            });

            AppRoutes.makeFirst(context, Dashboard());
            // if(email=="admin@gmail.com"&& password=="admin@123"){
            //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Dashboard()));
            //    }
            // else {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (context) => Dashboard()));
            //   }

          } else {
            Fluttertoast.showToast(msg: 'Login failed!');
            setState(() {
              error = 'Error signing in!';
              _isLoading = false;
            });
          }
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Login failed!');
        setState(() {
          error = 'Error signing in!';
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
                'Login',
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
                        image: AssetImage("assets/backg.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Container(
                            height: height,
                            width: width,
                            child: Column(
                              children: [
                                Container(height: height * 0.15),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                    child: Container(
                                      height: height * 0.65,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: height * 0.03,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: Text("Login",
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                    style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty.all<Color>(
                                                                Colors.white),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors.red),
                                                        shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(18.0),
                                                                side: BorderSide(color: Colors.red)))),
                                                    onPressed: () => null),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                RegisterPage()));
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 30),
                                                    child: Text(
                                                      "Signup",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 0),
                                              child: Theme(
                                                data: new ThemeData(
                                                  // primaryColor: Colors.red,
                                                  primaryColorDark:
                                                      Colors.black54,
                                                ),
                                                child: TextFormField(
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  controller: emailController,
                                                  decoration:
                                                      new InputDecoration(
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          border:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey),
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
                                                          hintText:
                                                              "Enter Username Or Email"),
                                                  validator: (val) {
                                                    return RegExp(
                                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                            .hasMatch(val)
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 0),
                                              child: Theme(
                                                data: new ThemeData(
                                                  // primaryColor: Colors.red,
                                                  primaryColorDark:
                                                      Colors.black,
                                                ),
                                                child: TextFormField(
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  controller:
                                                      passwordController,
                                                  decoration:
                                                      new InputDecoration(
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          border:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey),
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
                                                  validator: (val) => val
                                                              .length <
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20, top: 20),
                                                  child: Text(
                                                    "Forgot Password",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: height * 0.06,
                                            ),
                                            Container(
                                              height: height * 0.06,
                                              width: width * 0.4,
                                              child: RaisedButton(
                                                  elevation: 0.0,
                                                  color: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0)),
                                                  child: Text('Login',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0)),
                                                  onPressed: () {
                                                    _onSignIn();
                                                  }),
                                            ),
                                            SizedBox(
                                              height: height * 0.03,
                                            ),
                                            /* Text(
                                            "OR",
                                            style: TextStyle(
                                                color: Colors.black12,
                                                fontSize: 28),
                                          ), */
                                            SizedBox(
                                              height: height * 0.02,
                                            ),
                                            /* Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Login with facebook failed! Facebook app error');
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
                                                  onTap: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    User user =
                                                        await AuthService()
                                                            .signInWithGoogle();
                                                    await CurrentAppUser
                                                        .currentUserData
                                                        .getUserData();
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    if (user != null) {
                                                      Fluttertoast.showToast(
                                                          msg: 'User Logged-in!');
                                                      AppRoutes.makeFirst(
                                                          context, Dashboard());
                                                    } else {}
                                                  },
                                                  child: Image.asset(
                                                    "images/google.png",
                                                    height: 45,
                                                    width: 45,
                                                  )),
                                            ],
                                          ) */
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
