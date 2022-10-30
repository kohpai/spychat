import 'package:basic_utils/basic_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Generate ECC key pair', () {
    final keyPair = CryptoUtils.generateEcKeyPair(curve: 'secp384r1');
    final privateKey = keyPair.privateKey as ECPrivateKey;
    expect(privateKey.parameters?.domainName, equals('secp384r1'));
  });
}
