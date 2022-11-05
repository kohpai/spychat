import 'dart:convert';

import 'package:spychat/packet.dart';
import 'package:test/test.dart';

void main() {
  test('Serialize Packet to JSON', () {
    final now = DateTime.now();
    final nowStr = now.toIso8601String();
    const pubKey = "my_pub_key";
    const data = "my_data";
    final connectPacket = Packet.connect(pubKey, now);
    expect(jsonEncode(connectPacket),
        equals('{"cmd":"CNT","pubKey":"$pubKey","signedAt":"$nowStr"}'));

    final signalPacket = Packet.signal(pubKey, data, now);
    expect(
        jsonEncode(signalPacket),
        equals(
            '{"cmd":"SGN","pubKey":"$pubKey","signedAt":"$nowStr","data":"$data"}'));
  });

  test('Deserialize JSON to Packet', () {
    final now = DateTime.now();
    final nowStr = now.toIso8601String();
    const pubKey = "my_pub_key";
    const data = "my_data";
    final connectJson = '{"cmd":"CNT","pubKey":"$pubKey","signedAt":"$nowStr"}';
    final connectPacket = Packet.connect(pubKey, now);
    expect(Packet.fromJson(jsonDecode(connectJson)), equals(connectPacket));

    final signalJson =
        '{"cmd":"SGN","pubKey":"$pubKey","signedAt":"$nowStr","data":"$data"}';
    final signalPacket = Packet.signal(pubKey, data, now);
    expect(Packet.fromJson(jsonDecode(signalJson)), equals(signalPacket));
  });
}
