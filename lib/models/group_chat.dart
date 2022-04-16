import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChat {
  String id;
  String name;
  String createdby;
  Timestamp createdAt;
  Timestamp lastMessageTime;
  String lastMessage;
  String lastMessageby;
  List<dynamic> members;
  GroupChat({
    this.id,
    this.name,
    this.createdby,
    this.createdAt,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageby,
    this.members,
  });
  static GroupChat fromMap(Map<String, dynamic> map) {
    GroupChat c = GroupChat();
    c.id = map['id'];
    c.name = map['name'];
    c.createdAt = map['created_at'];
    c.createdby = map['created_by'];
    c.lastMessage = map['last_message'];
    c.lastMessageTime = map['last_message_time'];
    c.lastMessageby = map['last_message_by'];
    c.members = map['members'];

    return c;
  }

  // static Map<String, dynamic> toMap(AppUser user) {
  //   return {
  //     'user_id': user.userId,
  //     'email': user.email,
  //     'fullName': user.name,
  //     'created_at': user.createdAt,
  //     'phone': user.phone,
  //     'address': user.address
  //   };
  // }
}
