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
            String pubKey = snapshot.data!.first;
            print(pubKey);
            return SelectableText(pubKey);
          } else if (snapshot.hasError) {
            return SelectableText('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      );
}
