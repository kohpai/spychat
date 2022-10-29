import 'package:pointycastle/export.dart';

AsymmetricKeyPair<ECPublicKey, ECPrivateKey> generateECkeyPair(
    SecureRandom secureRandom,
    {String domainName = 'secp384r1'}) {
  final keyGen = KeyGenerator('EC');
  keyGen.init(ParametersWithRandom(
      ECKeyGeneratorParameters(ECDomainParameters(domainName)), secureRandom));

  final pair = keyGen.generateKeyPair();
  final publicKey = pair.publicKey as ECPublicKey;
  final privateKey = pair.privateKey as ECPrivateKey;

  return AsymmetricKeyPair(publicKey, privateKey);
}
