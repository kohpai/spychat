import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:spychat/signaling/kay_pair_provider.dart';

class KeyPemDisplay extends StatelessWidget {
  late final Future<Pair<String, ECPrivateKey>> _futureKeyPair;

  KeyPemDisplay({super.key}) {
    _futureKeyPair = KeyPairProvider.getKeyPair();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<Pair<String, ECPrivateKey>>(
        future: _futureKeyPair,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: <Widget>[
              Text(snapshot.data!.first),
              Text(CryptoUtils.encodeEcPrivateKeyToPem(snapshot.data!.last))
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      );
}
