// import 'package:cloud_firestore/cloud_firestore.dart';

// class Message {
//   String? senderId;
//   String? receiverId;
//   String? type;
//   String? message;
//   Timestamp? timestamp;
//   String? photoUrl;
//   String? fileUrl;
//   String? fileName;
//   String? fileSize;

//   Message({
//     this.senderId,
//     this.receiverId,
//     this.type,
//     this.message,
//     this.timestamp,
//   });

//   //Will be only called when you wish to send an image
//   // named constructor
//   Message.imageMessage({
//     this.senderId,
//     this.receiverId,
//     this.message,
//     this.type,
//     this.timestamp,
//     this.photoUrl,
//   });

//   Message.fileMessage({
//     this.senderId,
//     this.receiverId,
//     this.message,
//     this.type,
//     this.timestamp,
//     this.fileUrl,
//     this.fileName,
//     this.fileSize,
//   });

//   Map toMap() {
//     var map = Map<String?, dynamic>();
//     map['senderId'] = this.senderId;
//     map['receiverId'] = this.receiverId;
//     map['type'] = this.type;
//     map['message'] = this.message;
//     map['timestamp'] = this.timestamp;
//     return map;
//   }

//   Map toImageMap() {
//     var map = Map<String, dynamic>();
//     map['message'] = this.message;
//     map['senderId'] = this.senderId;
//     map['receiverId'] = this.receiverId;
//     map['type'] = this.type;
//     map['timestamp'] = this.timestamp;
//     map['photoUrl'] = this.photoUrl;
//     return map;
//   }

//   Message.fromMap(Map<String?, dynamic> map) {
//     this.senderId = map['senderId'];
//     this.receiverId = map['receiverId'];
//     this.type = map['type'];
//     this.message = map['message'];
//     this.timestamp = map['timestamp'];
//     this.photoUrl = map['photoUrl'];
//     this.fileName = map['name'];
//     this.fileSize = map['size'];
//     this.fileUrl = map['fileUrl'];
//   }

//   Map<String, Object?> toJson() {
//     return {
//       'senderId': senderId,
//       'receiverId': receiverId,
//       'type': type,
//       'message': message,
//       'timestamp': timestamp
//     };
//   }

//   Map<String, Object?> toJsonImage() {
//     return {
//       'senderId': senderId,
//       'receiverId': receiverId,
//       'type': type,
//       'message': message,
//       'photoUrl': photoUrl,
//       'timestamp': timestamp
//     };
//   }

//   Map<String, Object?> toJsonFile() {
//     return {
//       'senderId': senderId,
//       'receiverId': receiverId,
//       'type': type,
//       'message': message,
//       'fileUrl': fileUrl,
//       'name': fileName,
//       'size': fileSize,
//       'timestamp': timestamp
//     };
//   }
// }

import 'package:connect_chat/constants/strings.dart';
import 'package:json_annotation/json_annotation.dart';

import 'reply_message.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'message.g.dart';

@JsonSerializable(explicitToJson: true)
class Message {
  String? content;
  String? fromId;
  String? toId;
  String? timeStamp;
  DateTime? sendDate;
  bool? isSeen;
  MessageType? type;
  MediaType? mediaType;
  String? mediaUrl;
  String? fileSize;
  String? fileName;
  String? extensionfile;
  bool? uploadFinished;
  ReplyMessage? reply;

  Message({
    this.content,
    this.fromId,
    this.toId,
    this.timeStamp,
    this.sendDate,
    this.fileSize,
    this.isSeen,
    this.extensionfile,
    this.fileName,
    this.type,
    this.mediaType,
    this.mediaUrl,
    this.uploadFinished,
    this.reply,
  });

  factory Message.fromMap(Map<String, dynamic> data) {
    return _$MessageFromJson(data);
  }

  static Map<String, dynamic> toMap(Message message) {
    return _$MessageToJson(message);
  }
}
