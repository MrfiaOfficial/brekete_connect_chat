// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyMessage _$ReplyMessageFromJson(Map<String, dynamic> json) {
  return ReplyMessage(
    content: json['content'] as String?,
    replierId: json['replierId'] as String?,
    repliedToId: json['repliedToId'] as String?,
    type: _$enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$ReplyMessageToJson(ReplyMessage instance) =>
    <String, dynamic>{
      'content': instance.content,
      'replierId': instance.replierId,
      'repliedToId': instance.repliedToId,
      'type': _$MessageTypeEnumMap[instance.type],
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
