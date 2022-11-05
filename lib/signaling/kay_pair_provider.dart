import 'dart:developer' as developer;

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Pair<T, U> {
  final T first;
  final U last;

  Pair(this.first, this.last);
}

class KeyPairProvider {
  static Pair<String, ECPrivateKey>? _keyPair;

  static Future<Pair<String, ECPrivateKey>> getKeyPair() async {
    if (_keyPair == null) {
      final keyPair = await _getKeyPair();
      final publicKey = keyPair.publicKey as ECPublicKey;
      final privateKey = keyPair.privateKey as ECPrivateKey;
      final pubKeyPem = CryptoUtils.encodeEcPublicKeyToPem(publicKey);
      _keyPair = Pair(pubKeyPem, privateKey);
    }
    return _keyPair!;
  }

  static Future<AsymmetricKeyPair>
      _getKeyPair() async {
    const storage = FlutterSecureStorage();

    return Future.wait(
            [storage.read(key: 'public_key'), storage.read(key: 'private_key')])
        .then((pems) async {
      if (pems.any((pem) => pem == null)) {
        developer.log('Key(s) NOT found', name: 'me.kohpai.main');
        final keyPair = CryptoUtils.generateEcKeyPair(curve: 'secp384r1');
        await Future.wait([
          storage.write(
              key: 'public_key',
              value: CryptoUtils.encodeEcPublicKeyToPem(
                  keyPair.publicKey as ECPublicKey)),
          storage.write(
              key: 'private_key',
              value: CryptoUtils.encodeEcPrivateKeyToPem(
                  keyPair.privateKey as ECPrivateKey))
        ]);
        return keyPair;
      }

      developer.log('Keys FOUND', name: 'me.kohpai.main');
      final publicKey = CryptoUtils.ecPublicKeyFromPem(pems[0]!);
      final privateKey = CryptoUtils.ecPrivateKeyFromPem(pems[1]!);
      return AsymmetricKeyPair(publicKey, privateKey);
    });
  }
}
