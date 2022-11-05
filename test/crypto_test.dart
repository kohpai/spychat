import 'package:basic_utils/basic_utils.dart';

void main() async {
  // printEcKeyPair();
}

void printEcKeyPair() {
  final keyPair = CryptoUtils.generateEcKeyPair(curve: 'secp384r1');
  final privateKey = keyPair.privateKey as ECPrivateKey;
  final publicKey = keyPair.publicKey as ECPublicKey;
  print(CryptoUtils.encodeEcPrivateKeyToPem(privateKey));
  print(CryptoUtils.encodeEcPublicKeyToPem(publicKey));
}
