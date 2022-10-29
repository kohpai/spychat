import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:pointycastle/api.dart';
import 'package:test/test.dart';

import 'package:spychat/crypto.dart';

void main() {
  test('Generate ECC key pair', () {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(
          KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
    final AsymmetricKeyPair<ECPublicKey, ECPrivateKey> keyPair =
        generateECkeyPair(secureRandom, domainName: 'secp384r1');
    expect(keyPair.privateKey.parameters?.domainName, equals('secp384r1'));
  });
}
