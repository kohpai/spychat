import 'package:json_annotation/json_annotation.dart';

part 'packet.g.dart';

enum Command {
  @JsonValue('CNT')
  cnt,
  @JsonValue('SGN')
  sgn
}

@JsonSerializable(includeIfNull: false)
class Packet {
  Packet(this.cmd, this.pubKey, this.signedAt, [this.data]);

  final Command cmd;
  final String pubKey;
  final DateTime signedAt;
  final String? data;

  factory Packet.fromJson(Map<String, dynamic> json) => _$PacketFromJson(json);

  factory Packet.connect(String pubKey, DateTime signedAt) =>
      Packet(Command.cnt, pubKey, signedAt);

  factory Packet.signal(String pubKey, String data, DateTime signedAt) =>
      Packet(Command.sgn, pubKey, signedAt, data);

  Map<String, dynamic> toJson() => _$PacketToJson(this);

  @override
  bool operator ==(Object other) {
    if (other is! Packet) return false;

    return other.cmd == cmd &&
        other.pubKey == pubKey &&
        other.data == data &&
        other.signedAt == signedAt;
  }
}
