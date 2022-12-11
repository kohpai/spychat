import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:spychat/signaling/kay_pair_provider.dart';
import 'package:spychat/signaling/packet.dart';

const algorithm = 'SHA-256/ECDSA';

Future<String> encapsulatePacket([String? dstPubKey, String data = ""]) async {
  final keyPair = await KeyPairProvider.getKeyPair();

  final pubKey = keyPair.first;
  final now = DateTime.now().toUtc();
  final packet = dstPubKey == null
      ? Packet.connect(pubKey, now)
      : Packet.signal(dstPubKey, data, now);
  final packetJson = jsonEncode(packet);
  final signature = CryptoUtils.ecSign(
      keyPair.last, Uint8List.fromList(utf8.encode(packetJson)),
      algorithmName: algorithm);

  return '$packetJson;${CryptoUtils.ecSignatureToBase64(signature)}';
}

Future<bool> verifyPacket(Packet packet, String signature) async {
  final keyPair = await KeyPairProvider.getKeyPair();
  final pubKey = keyPair.first;
  final originalPacket = Packet.signal(pubKey, packet.data!, packet.signedAt);
  final json = jsonEncode(originalPacket);
  final senderPubKey = CryptoUtils.ecPublicKeyFromPem(packet.pubKey);
  return CryptoUtils.ecVerify(
      senderPubKey,
      Uint8List.fromList(utf8.encode(json)),
      CryptoUtils.ecSignatureFromBase64(signature),
      algorithm: algorithm);
}
