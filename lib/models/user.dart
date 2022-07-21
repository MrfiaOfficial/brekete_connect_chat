import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CurrentAppUser with ChangeNotifier {
  static final CurrentAppUser _singleton = CurrentAppUser._internal();
  factory CurrentAppUser() => _singleton;
  CurrentAppUser._internal();
  static CurrentAppUser get currentUserData => _singleton;
  late String email;
  late String userId;
  late String name;
  late String phone;
  late String address;
  late String photo;
  late List<String> groups = [];
  late List<dynamic> messages;

  Future<bool> getUserData() async {
    // print(
    //     "US             {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{ ${CurrentAppUser.currentUserData.userId}");

    FirebaseFirestore.instance
        .collection('users')
        .doc('${CurrentAppUser.currentUserData.userId}')
        .snapshots()
        .listen((event) {
      Map<String, dynamic> data = event.data() as Map<String, dynamic>;
      CurrentAppUser.currentUserData.email = data['email'];
      CurrentAppUser.currentUserData.name = data['fullName'];
      CurrentAppUser.currentUserData.address = data['address'];
      CurrentAppUser.currentUserData.phone = data['phone'];
      CurrentAppUser.currentUserData.photo = data['profilePic'];
      CurrentAppUser.currentUserData.messages = data['messages'] ?? [];
      // groups = userDoc['group'];
      notifyListeners();
    });
    return true;
  }
}

class User {
  final String uid;

  User({required this.uid});
}
