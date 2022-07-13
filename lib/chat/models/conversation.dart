import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String? uid;
  Timestamp? addedOn;

  Conversation({
    this.uid,
    this.addedOn,
  });

  Conversation.fromJson(Map<String?, Object?> json)
      : this(
          uid: json['conversation_id']! as String,
          addedOn: json['added_on']! as Timestamp,
        );

  Map toMap(Conversation conversation) {
    var data = Map<String, dynamic>();
    data['conversation_id'] = conversation.uid;
    data['added_on'] = conversation.addedOn;
    return data;
  }

  Conversation.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['conversation_id'];
    this.addedOn = mapData["added_on"];
  }
}
