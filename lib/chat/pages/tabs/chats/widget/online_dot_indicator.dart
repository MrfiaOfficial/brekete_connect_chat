import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_chat/enum/user_state.dart';
import 'package:connect_chat/models/user_model.dart';
import 'package:connect_chat/services/auth_firebase.dart';
import 'package:connect_chat/utility/utilityStatus.dart';
import 'package:flutter/material.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String? uid;
  final AuthFirebase _authFirebase = AuthFirebase();
  OnlineDotIndicator({required this.uid});

  @override
  Widget build(BuildContext context) {
    getStatus(int? status) {
      switch (UtilityStatus.numToState(status!)) {
        case UserState.Offline:
          return Colors.transparent;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.transparent;
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: StreamBuilder<DocumentSnapshot>(
          stream: _authFirebase.getUserStream(uid: uid),
          builder: (context, snapshot) {
            UserData? _userData;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (snapshot.hasData && snapshot.data!.data() != null) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              _userData = UserData.fromMap(data);
            }
            return Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.only(right: 5, top: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getStatus(_userData!.status),
              ),
            );
          }),
    );
  }
}
