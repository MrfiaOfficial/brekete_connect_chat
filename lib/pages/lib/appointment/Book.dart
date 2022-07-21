import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/utils/routes.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class Book extends StatefulWidget {
  const Book({Key? key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Book> {
  List<String> _status = [
    'Approved',
    'In-Review',
    'Disapproved',
  ];

  String _selectedStatus = 'In-Review';
  late String timef;
  String vot = "Time";
  final name = TextEditingController();
  final phone = TextEditingController();
  final time = TextEditingController();
  final description = TextEditingController();
  final comment = TextEditingController();

  GlobalKey<FormState> fKey = GlobalKey<FormState>();

  late String _formattedDate;
  DateTime? selectedDate; // = DateTime.now();
  TimeOfDay? selectedTime; // = TimeOfDay.now();
  late bool isLoading;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      /* builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.red,
            accentColor: Colors.red,
            colorScheme: ColorScheme.light(primary: Colors.red),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      }, */
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _formattedDate = selectedDate!.toLocal().toString().split(' ')[0];
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      /* builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      }, */
    );

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
        timef = selectedTime.toString();
        vot = timef.substring(10, 15);
      });
  }

  Future<bool> _createAppointment() async {
    try {
      Map<String, dynamic> chatMessageMap = {
        'created_at': Timestamp.now(),
        'creater_id': CurrentAppUser.currentUserData.userId,
        "name": name.text,
        "phone": phone.text,
        "date": _formattedDate,
        "time": vot,
        "description": description.text,
        'status': _selectedStatus,
        'comment': '',
        // "sender": widget.userName,
        // 'time': DateTime.now().millisecondsSinceEpoch,
      };
      await FirebaseFirestore.instance
          .collection('Booked_Appointment')
          .doc()
          .set(chatMessageMap);

      //DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        name.text = "";
        phone.text = "";
        description.text = "";
        comment.text = "";
        // name.text = "";
      });
      Fluttertoast.showToast(
          msg: 'Appointment Successfully Added!',
          timeInSecForIosWeb: 3,
          gravity: ToastGravity.TOP);
      AppRoutes.pop(context);
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong!');
      return false;
    }
  }

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

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
      home: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
                onTap: () {
                  AppRoutes.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Text(
              'Book Appointment',
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
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                child: SingleChildScrollView(
                  child: Form(
                    key: fKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'BOOK APPOINTMENT',
                          style: TextStyle(
                            color: Color.fromARGB(255, 49, 76, 190),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          'Fill the form below to Book an appointment  with the ordinary President before coming  to the office ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        TextFormField(
                          validator: (v) => v!.isEmpty ? 'Insert Name!' : null,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          controller: name,
                          style: TextStyle(color: Colors.black),
                          decoration: new InputDecoration(
                              hintStyle: TextStyle(
                                color: Colors.black54,
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 0, bottom: 2, top: 11, right: 15),
                              hintText: "Name"),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        TextFormField(
                          controller: phone,
                          validator: (v) => v!.isEmpty ? 'Insert Phone!' : null,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: Colors.black),
                          decoration: new InputDecoration(
                              hintStyle: TextStyle(
                                color: Colors.black54,
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 0, bottom: 2, top: 11, right: 15),
                              hintText: "Phone"),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            width: width,
                            // height: ,
                            child: Text(
                              selectedDate == null
                                  ? 'Select Date'
                                  : "${selectedDate!.toLocal()}".split(' ')[0],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        GestureDetector(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: Container(
                            width: width,
                            child: Text(
                              "${vot}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        // ElevatedButton(
                        //   child: Text(
                        //       "Select Time",
                        //       style: TextStyle(fontSize: 20)
                        //   ),
                        //   style: ButtonStyle(
                        //       foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        //       backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //           RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(12.0),
                        //               side: BorderSide(color: Colors.red)
                        //           )
                        //       )
                        //   ),
                        //   onPressed: (){
                        //     _selectTime(context);
                        //   },
                        // ),

                        //   ],
                        // ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),

                        SizedBox(
                          child: Container(
                            // width: width,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 4,
                                      offset: Offset(1, 1))
                                ]),
                            child: TextFormField(
                              controller: description,
                              // minLines: 5,
                              maxLines: 7,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: 'Brief Description',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        // ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Container(
                          height: height * 0.06,
                          child: ElevatedButton(
                            child: Text("BOOK NOW",
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
                                        side: BorderSide(color: Colors.red)))),
                            onPressed: () async {
                              print("++++++++++++++++++++++++++++++++++++++++");
                              if (fKey.currentState!.validate()) {
                                if (selectedDate != null) {
                                  if (selectedTime != null) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await _createAppointment();
                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Add Time!',
                                        gravity: ToastGravity.TOP);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Add Date!',
                                      gravity: ToastGravity.TOP);
                                }
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
