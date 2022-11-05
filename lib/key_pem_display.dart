import 'dart:developer' as developer;

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyPemDisplay extends StatelessWidget {
  late final Future<AsymmetricKeyPair> futureKeyPair;

  KeyPemDisplay({super.key}) {
    futureKeyPair = getKeyPair();
  }

  //TODO: make this into a singleton for accessing the key pair
  Future<AsymmetricKeyPair> getKeyPair() async {
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

  @override
  Widget build(BuildContext context) => FutureBuilder<AsymmetricKeyPair>(
    future: futureKeyPair,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final publicKey = snapshot.data!.publicKey as ECPublicKey;
        final privateKey = snapshot.data!.privateKey as ECPrivateKey;
        return Column(children: <Widget>[
          Text(CryptoUtils.encodeEcPublicKeyToPem(publicKey)),
          Text(CryptoUtils.encodeEcPrivateKeyToPem(privateKey))
        ]);
      } else if (snapshot.hasError) {
        return Text('${snapshot.error}');
      }

      return const CircularProgressIndicator();
    },
  );
}
