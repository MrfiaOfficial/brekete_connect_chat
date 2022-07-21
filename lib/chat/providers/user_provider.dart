import 'package:brekete_connect/chat/models/user_model.dart';
import 'package:brekete_connect/chat/services/auth_firebase.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserData? _userData;
  AuthFirebase _authMethods = AuthFirebase();

  UserData? get getUser => _userData;

  Future<void> refreshUser() async {
    UserData? userData = await _authMethods.getUserDetails();
    _userData = userData;
    notifyListeners();
  }
}
