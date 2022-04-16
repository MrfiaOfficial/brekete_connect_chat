import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String email;
  String userId;
  String name;
  String phone;
  String address;
  List<String> groups = [];
  Timestamp createdAt;
  List<dynamic> messages;
  AppUser(
      {this.email,
      this.userId,
      this.name,
      this.phone,
      this.address,
      this.groups,
      this.createdAt,
      this.messages});
  static AppUser fromMap(Map<String, dynamic> map) {
    AppUser appUser = AppUser();
    appUser.userId = map['uid'];
    appUser.email = map['email'];
    appUser.name = map['fullName'];
    appUser.phone = map['phone'];
    appUser.phone = map['address'];
    appUser.createdAt = map['created_at'];
    appUser.messages = map['messages'] ?? [];

    return appUser;
  }

  static Map<String, dynamic> toMap(AppUser user) {
    return {
      'user_id': user.userId,
      'email': user.email,
      'fullName': user.name,
      'created_at': user.createdAt,
      'phone': user.phone,
      'address': user.address
    };
  }
}
