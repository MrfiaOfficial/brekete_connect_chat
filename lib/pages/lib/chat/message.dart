import 'dart:convert';

import 'package:flutter/material.dart';

class Message {
  final String ownerId;
  final String message;
  final String createdAt;
  bool seen;

  Message({this.ownerId, this.message, this.createdAt, @required this.seen});

  Message copyWith(
      {String ownerId, String message, String createdAt, String seen}) {
    return Message(
      ownerId: ownerId ?? this.ownerId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      seen: seen ?? this.seen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'message': message,
      'createdAt': createdAt,
      'seen': seen
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Message(
        ownerId: map['ownerId'],
        message: map['message'],
        createdAt: map['createdAt'],
        seen: map['seen'] ?? true);
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() =>
      'Message(ownerId: $ownerId, message: $message, createdAt: $createdAt)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Message &&
        o.ownerId == ownerId &&
        o.message == message &&
        o.seen == seen &&
        o.createdAt == createdAt;
  }

  @override
  int get hashCode => ownerId.hashCode ^ message.hashCode ^ createdAt.hashCode;
}
