import 'dart:developer' as developer;

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyPairProvider {
  static AsymmetricKeyPair? _keyPair;

  static Future<AsymmetricKeyPair>
      getKeyPair() async {
    if (_keyPair == null) {
      final keyPair = await _getKeyPair();
      _keyPair = keyPair;
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
