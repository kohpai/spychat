import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:spychat/signaling/kay_pair_provider.dart';
import 'package:spychat/signaling/packet.dart';

Future<String> encapsulatePacket([String? data]) async {
  final keyPair = await KeyPairProvider.getKeyPair();

  final pubKey = keyPair.first;
  final now = DateTime.now().toUtc();
  final packet = data == null
      ? Packet.connect(pubKey, now)
      : Packet.signal(pubKey, data, now);
  final packetJson = jsonEncode(packet);
  final signature = CryptoUtils.ecSign(
      keyPair.last, Uint8List.fromList(utf8.encode(packetJson)), algorithmName: 'SHA-256/ECDSA');

  return '$packetJson;${CryptoUtils.ecSignatureToBase64(signature)}';
}
