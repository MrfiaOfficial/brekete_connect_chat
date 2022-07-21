import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:brekete_connect/models/user.dart';
import 'package:brekete_connect/utils/routes.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NewMediationScreen extends StatefulWidget {
  const NewMediationScreen({Key? key}) : super(key: key);

  @override
  _NewMediationScreenState createState() => _NewMediationScreenState();
}

class _NewMediationScreenState extends State<NewMediationScreen> {
  List<String> _case = [
    'Family',
    'Government',
    'Corporate',
    'Business',
    'School',
    'Religion',
    'Individual',
    'Community',
    'Property Estate',
    'Others'
  ];

  List<String> _status = [
    'Approved',
    'In-Review',
    'Disapproved',
  ];

  List<String> _gender = ['Male', 'Female'];
  bool? checked;
  String _selectedcase = 'Family';
  String _selectedStatus = 'In-Review';
  String _fpgender = 'Male';
  String _spgender = 'Male';

  String? timef;
  String vot = "Time";
  final firstPersonName = TextEditingController();
  final firstPersonPhone = TextEditingController();
  final firstPersonGender = TextEditingController();
  final firstPersonAddress = TextEditingController();

  final secondPersonName = TextEditingController();
  final secondPersonPhone = TextEditingController();
  final secondPersonGender = TextEditingController();
  final secondPersonAddress = TextEditingController();

  final time = TextEditingController();
  final subject = TextEditingController();
  final description = TextEditingController();
  final comment = TextEditingController();

  GlobalKey<FormState> fKey = GlobalKey<FormState>();

  DateTime? selectedDate; // = DateTime.now();
  TimeOfDay? selectedTime; // = TimeOfDay.now();
  bool? isLoading;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.red,
            accentColor: Colors.red,
            colorScheme: ColorScheme.light(primary: Colors.red),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
        timef = selectedTime.toString();
        vot = timef.substring(10, 15);
      });
  }

  Future<bool> _createMediation() async {
    try {
      Map<String, dynamic> formDataMap = {
        'created_at': Timestamp.now(),
        'creater_id': CurrentAppUser.currentUserData.userId,

        "firstPersonName": firstPersonName.text,
        "firstPersonPhone": firstPersonPhone.text,
        "firstPersonGender": _fpgender,
        "firstPersonAddress": firstPersonAddress.text,

        "secondPersonName": secondPersonName.text,
        "secondPersonPhone": secondPersonPhone.text,
        "secondPersonGender": _spgender,
        "secondPersonAddress": secondPersonAddress.text,

        "subject": subject.text,
        "description": description.text,
        'case_type': _selectedcase,
        'status': _selectedStatus,
        'comment': '',
        // "sender": widget.userName,
        // 'time': DateTime.now().millisecondsSinceEpoch,
      };
      await FirebaseFirestore.instance
          .collection('mediations')
          .doc()
          .set(formDataMap);

      //DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        firstPersonName.text = "";
        firstPersonPhone.text = "";
        //firstPersonGender.text = "";
        firstPersonAddress.text = "";

        secondPersonName.text = "";
        secondPersonPhone.text = "";
        //secondPersonGender.text = "";
        secondPersonAddress.text = "";

        subject.text = "";
        description.text = "";
        comment.text = "";
      });
      Fluttertoast.showToast(
          msg: 'Mediation Successfully Requested!',
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
    checked = false;
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
              'Request Mediation',
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
                        Center(
                          child: Text(
                            'REQUEST MEDIATION',
                            style: TextStyle(
                              color: Color.fromARGB(255, 49, 76, 190),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  value: checked,
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.all<Color>(
                                      Colors.blue),
                                  onChanged: (v) {
                                    checked = v!;
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'I ACCEPT TERMS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 49, 76, 190),
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Text(
                            'By checking the box above, you have accepted the terms and conditions of the Ordinary President and have officially requested the Ordinary President to mediate between you parties stated herein.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 49, 76, 190),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: height * 0.04,
                        ),
                        Center(
                          child: Text(
                            'Fill the form below to submit a complaint ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'CASE TYPE',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: height * 0.05,
                              //width: width * 0.4,
                              decoration: BoxDecoration(
                                  color: Color(0XFFEFF3F6),
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.1),
                                        offset: Offset(6, 2),
                                        blurRadius: 6.0,
                                        spreadRadius: 3.0),
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.9),
                                        offset: Offset(-6, -2),
                                        blurRadius: 6.0,
                                        spreadRadius: 3.0)
                                  ]),
                              // child: DropdownButtonHideUnderline(
                              // child: ButtonTheme(
                              // alignedDropdown: true,
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    // hint: Text('Place                                                                          '), // Not necessary for Option 1
                                    value: _selectedcase,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedcase = newValue.toString();
                                      });
                                    },
                                    items: _case.map((location) {
                                      return DropdownMenuItem(
                                        child: new Text(location),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),

                        // First participant Fields
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FIRST PARTICIPANT',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                validator: (v) =>
                                    v!.isEmpty ? 'Insert Full Name!' : null,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                controller: firstPersonName,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Full Name"),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                controller: firstPersonPhone,
                                validator: (v) =>
                                    v!.isEmpty ? 'Insert Phone!' : null,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Phone Number"),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                validator: (v) =>
                                    v!.isEmpty ? 'Insert Address!' : null,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                controller: firstPersonAddress,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Address"),
                              ),
                              SizedBox(
                                height: height * 0.04,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gender',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    height: height * 0.05,
                                    width: width * 0.4,
                                    decoration: BoxDecoration(
                                        color: Color(0XFFEFF3F6),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                              offset: Offset(6, 2),
                                              blurRadius: 6.0,
                                              spreadRadius: 3.0),
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.9),
                                              offset: Offset(-6, -2),
                                              blurRadius: 6.0,
                                              spreadRadius: 3.0)
                                        ]),
                                    // child: DropdownButtonHideUnderline(
                                    // child: ButtonTheme(
                                    // alignedDropdown: true,
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton(
                                          // hint: Text('Place                                                                          '), // Not necessary for Option 1
                                          value: _fpgender,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _fpgender = newValue.toString();
                                            });
                                          },
                                          items: _gender.map((location) {
                                            return DropdownMenuItem(
                                              child: new Text(location),
                                              value: location,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.04,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: height * 0.03,
                        ),

                        // Second Participant Fields
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SECOND PARTICIPANT',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                validator: (v) =>
                                    v!.isEmpty ? 'Insert Full Name!' : null,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                controller: secondPersonName,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Full Name"),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                controller: secondPersonPhone,
                                validator: (v) =>
                                    v!.isEmpty ? 'Insert Phone!' : null,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Phone Number"),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                validator: (v) =>
                                    v!.isEmpty ? 'Insert Address!' : null,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                controller: secondPersonAddress,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Address"),
                              ),
                              SizedBox(
                                height: height * 0.04,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gender',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    height: height * 0.05,
                                    width: width * 0.4,
                                    decoration: BoxDecoration(
                                        color: Color(0XFFEFF3F6),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                              offset: Offset(6, 2),
                                              blurRadius: 6.0,
                                              spreadRadius: 3.0),
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.9),
                                              offset: Offset(-6, -2),
                                              blurRadius: 6.0,
                                              spreadRadius: 3.0)
                                        ]),
                                    // child: DropdownButtonHideUnderline(
                                    // child: ButtonTheme(
                                    // alignedDropdown: true,
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton(
                                          // hint: Text('Place                                                                          '), // Not necessary for Option 1
                                          value: _spgender,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _spgender = newValue.toString();
                                            });
                                          },
                                          items: _gender.map((location) {
                                            return DropdownMenuItem(
                                              child: new Text(location),
                                              value: location,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.04,
                              ),
                            ],
                          ),
                        ),

                        // Mediation Details
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CASE DETAILS',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                controller: subject,
                                validator: (v) =>
                                    v!.isEmpty ? 'Insert Subject!' : null,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Subject Of Complaint"),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              TextFormField(
                                controller: description,
                                maxLines: 5,
                                validator: (v) => v!.isEmpty
                                    ? 'Insert brief description!'
                                    : null,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(color: Colors.black),
                                decoration: new InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 0, bottom: 2, top: 11, right: 15),
                                    hintText: "Brief Description"),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: height * 0.06,
                          child: ElevatedButton(
                            child: Text("SUBMIT COMPLAINT",
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
                                await _createMediation();
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          height: 25.0,
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
