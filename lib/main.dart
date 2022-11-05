import 'dart:developer' as developer;

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: Center(
          child: KeyPemDisplay(),
        ),
      ),
    );
  }
}

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
  Widget build(BuildContext context) =>
      FutureBuilder<AsymmetricKeyPair>(
        future: futureKeyPair,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final publicKey = snapshot.data!.publicKey as ECPublicKey;
            final privateKey = snapshot.data!.privateKey as ECPrivateKey;
            return ListView(children: [
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