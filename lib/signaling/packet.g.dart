// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Packet _$PacketFromJson(Map<String, dynamic> json) => Packet(
      $enumDecode(_$CommandEnumMap, json['cmd']),
      json['pubKey'] as String,
      DateTime.parse(json['signedAt'] as String),
      json['data'] as String?,
    );

Map<String, dynamic> _$PacketToJson(Packet instance) {
  final val = <String, dynamic>{
    'cmd': _$CommandEnumMap[instance.cmd]!,
    'pubKey': instance.pubKey,
    'signedAt': instance.signedAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('data', instance.data);
  return val;
}

const _$CommandEnumMap = {
  Command.cnt: 'CNT',
  Command.sgn: 'SGN',
};
