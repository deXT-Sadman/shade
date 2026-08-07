import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';
import 'dart:typed_data';
import 'dart:math';
import '../constants/app_constants.dart';

class KeyManager {
  final FlutterSecureStorage secureStorage;
  KeyManager({required this.secureStorage});

  /// Returns the existing public key, or generates a fresh RSA keypair
  /// and persists the private key securely if none exists yet.
  Future<String> getOrCreatePublicKey() async {
    final existingPublic =
        await secureStorage.read(key: AppConstants.kPublicKey);
    if (existingPublic != null && existingPublic.isNotEmpty) {
      return existingPublic;
    }
    return _generateAndStoreKeyPair();
  }

  Future<String> _generateAndStoreKeyPair() async {
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(
            BigInt.parse('65537'), AppConstants.rsaKeySize, 64),
        _secureRandom(),
      ));

    final pair = keyGen.generateKeyPair();
    final publicKey = pair.publicKey as RSAPublicKey;
    final privateKey = pair.privateKey as RSAPrivateKey;

    final publicKeyEncoded = _encodePublicKeyToPem(publicKey);
    final privateKeyEncoded = _encodePrivateKeyToPem(privateKey);

    await secureStorage.write(
        key: AppConstants.kPublicKey, value: publicKeyEncoded);
    await secureStorage.write(
        key: AppConstants.kPrivateKey, value: privateKeyEncoded);

    return publicKeyEncoded;
  }

  SecureRandom _secureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  String _encodePublicKeyToPem(RSAPublicKey publicKey) {
    final modulus = publicKey.modulus!;
    final exponent = publicKey.exponent!;
    final payload = jsonEncode({
      'n': modulus.toRadixString(16),
      'e': exponent.toRadixString(16),
    });
    final b64 = base64Encode(utf8.encode(payload));
    return '-----BEGIN SHADOWCHAT PUBLIC KEY-----\n$b64\n-----END SHADOWCHAT PUBLIC KEY-----';
  }

  String _encodePrivateKeyToPem(RSAPrivateKey privateKey) {
    final payload = jsonEncode({
      'n': privateKey.n!.toRadixString(16),
      'e': privateKey.exponent!.toRadixString(16),
      'd': privateKey.privateExponent!.toRadixString(16),
      'p': privateKey.p!.toRadixString(16),
      'q': privateKey.q!.toRadixString(16),
    });
    final b64 = base64Encode(utf8.encode(payload));
    return '-----BEGIN SHADOWCHAT PRIVATE KEY-----\n$b64\n-----END SHADOWCHAT PRIVATE KEY-----';
  }
}
