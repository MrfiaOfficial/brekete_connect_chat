// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    content: json['content'] as String?,
    fromId: json['fromId'] as String?,
    toId: json['toId'] as String?,
    timeStamp: json['timeStamp'] as String?,
    sendDate: json['sendDate'] == null
        ? null
        : DateTime.parse(json['sendDate'] as String),
    fileSize: json['fileSize'] as String?,
    isSeen: json['isSeen'] as bool?,
    extensionfile: json['extensionfile'] as String?,
    fileName: json['fileName'] as String?,
    type: _$enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
    mediaType: _$enumDecodeNullable(_$MediaTypeEnumMap, json['mediaType']),
    mediaUrl: json['mediaUrl'] as String?,
    uploadFinished: json['uploadFinished'] as bool?,
    reply: json['reply'] == null
        ? null
        : ReplyMessage.fromJson(json['reply'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'content': instance.content,
      'fromId': instance.fromId,
      'toId': instance.toId,
      'timeStamp': instance.timeStamp,
      'sendDate': instance.sendDate?.toIso8601String(),
      'isSeen': instance.isSeen,
      'type': _$MessageTypeEnumMap[instance.type],
      'mediaType': _$MediaTypeEnumMap[instance.mediaType],
      'mediaUrl': instance.mediaUrl,
      'fileSize': instance.fileSize,
      'fileName': instance.fileName,
      'extensionfile': instance.extensionfile,
      'uploadFinished': instance.uploadFinished,
      'reply': instance.reply?.toJson(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$MessageTypeEnumMap = {
  MessageType.Text: 'Text',
  MessageType.Media: 'Media',
};

const _$MediaTypeEnumMap = {
  MediaType.Photo: 'Photo',
  MediaType.Video: 'Video',
  MediaType.Text: 'Text',
  MediaType.File: 'File',
};
