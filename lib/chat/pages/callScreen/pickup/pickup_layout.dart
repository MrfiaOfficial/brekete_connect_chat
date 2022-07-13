import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_chat/models/call.dart';
import 'package:connect_chat/pages/callScreen/pickup/pickup_screen.dart';
import 'package:connect_chat/providers/user_provider.dart';
import 'package:connect_chat/services/call_firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallFirebase callMethods = CallFirebase();

  PickupLayout({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (context.watch<UserProvider>().getUser != null &&
            context.watch<UserProvider>().getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(
                uid: context.watch<UserProvider>().getUser!.userId),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data!.data() != null) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                Call call = Call.fromMap(data);
                if (!call.hasDialled!) {
                  return PickupScreen(call: call);
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
