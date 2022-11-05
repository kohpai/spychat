import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:spychat/signaling/kay_pair_provider.dart';

class KeyPemDisplay extends StatelessWidget {
  late final Future<AsymmetricKeyPair> _futureKeyPair;

  KeyPemDisplay({super.key}) {
    _futureKeyPair = KeyPairProvider.getKeyPair();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<AsymmetricKeyPair>(
    future: _futureKeyPair,
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
