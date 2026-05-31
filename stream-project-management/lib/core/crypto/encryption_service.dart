import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart';
import 'package:uuid/uuid.dart';

/// 加密服务
/// 提供 AES-256-GCM 加密/解密功能
/// 遵循 NIST FIPS 197-upd1 标准
class EncryptionService {
  EncryptionService._();

  static final EncryptionService _instance = EncryptionService._();

  factory EncryptionService() => _instance;

  /// AES-256-GCM 加密
  /// [plaintext] 明文
  /// [key] 32字节密钥
  /// 返回 base64(nonce(12字节) + ciphertext + tag(16字节))
  String encryptAES256GCM(String plaintext, List<int> key) {
    if (key.length != 32) {
      throw ArgumentError('AES-256 密钥必须为 32 字节');
    }

    final secureRandom = _getSecureRandom();
    final nonce = secureRandom.nextBytes(12); // GCM 推荐 12 字节 nonce
    final keyBytes = Uint8List.fromList(key);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(keyBytes),
          128, // mac bit length
          nonce,
          Uint8List(0), // AAD
        ),
      );

    final plaintextBytes = utf8.encode(plaintext);
    final ciphertext = cipher.process(plaintextBytes);

    // 拼接 nonce + ciphertext (包含 tag)
    final result = Uint8List(nonce.length + ciphertext.length);
    result.setRange(0, nonce.length, nonce);
    result.setRange(nonce.length, result.length, ciphertext);

    return base64.encode(result);
  }

  /// AES-256-GCM 解密
  /// [ciphertext] base64(nonce + ciphertext + tag)
  /// [key] 32字节密钥
  /// 返回明文
  String decryptAES256GCM(String ciphertext, List<int> key) {
    if (key.length != 32) {
      throw ArgumentError('AES-256 密钥必须为 32 字节');
    }

    final data = base64.decode(ciphertext);
    if (data.length < 28) {
      // 12 nonce + 16 tag = 28 字节最小
      throw ArgumentError('密文长度无效');
    }

    final nonce = data.sublist(0, 12);
    final cipherBytes = data.sublist(12);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(
          KeyParameter(Uint8List.fromList(key)),
          128,
          nonce,
          Uint8List(0),
        ),
      );

    final plaintextBytes = cipher.process(cipherBytes);
    return utf8.decode(plaintextBytes);
  }

  /// AES-256-CBC 加密（用于云备份）
  /// [plaintext] 明文
  /// [key] 32字节密钥（实际使用 256-bit）
  /// 返回 base64(iv(16字节) + ciphertext)
  String encryptAES256CBC(String plaintext, List<int> key) {
    if (key.length != 32) {
      throw ArgumentError('AES-256 密钥必须为 32 字节');
    }

    final secureRandom = _getSecureRandom();
    final iv = secureRandom.nextBytes(16);

    // 使用 encrypt 包的 CBC 模式
    final encrypter = encrypt.Encrypter(
      encrypt.AES(
        encrypt.Key(Uint8List.fromList(key)),
        mode: encrypt.AESMode.cbc,
      ),
    );

    final encrypted = encrypter.encrypt(
      plaintext,
      iv: encrypt.IV(Uint8List.fromList(iv)),
    );

    final result = Uint8List(iv.length + encrypted.bytes.length);
    result.setRange(0, iv.length, iv);
    result.setRange(iv.length, result.length, encrypted.bytes);

    return base64.encode(result);
  }

  /// AES-256-CBC 解密（用于云备份）
  String decryptAES256CBC(String ciphertext, List<int> key) {
    if (key.length != 32) {
      throw ArgumentError('AES-256 密钥必须为 32 字节');
    }

    final data = base64.decode(ciphertext);
    if (data.length < 32) {
      throw ArgumentError('密文长度无效');
    }

    final iv = data.sublist(0, 16);
    final cipherBytes = data.sublist(16);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(
        encrypt.Key(Uint8List.fromList(key)),
        mode: encrypt.AESMode.cbc,
      ),
    );

    final decrypted = encrypter.decrypt(
      encrypt.Encrypted(Uint8List.fromList(cipherBytes)),
      iv: encrypt.IV(Uint8List.fromList(iv)),
    );

    return decrypted;
  }

  /// 为分享链接生成一次性密钥
  /// 返回 64 字符十六进制字符串（32字节）
  List<int> generateShareKey() {
    final secureRandom = _getSecureRandom();
    return secureRandom.nextBytes(32);
  }

  /// 分享数据加密（使用分享密钥）
  String encryptForShare(String data, List<int> shareKey) {
    return encryptAES256GCM(data, shareKey);
  }

  /// 分享数据解密（使用分享密钥）
  String decryptFromShare(String encryptedData, List<int> shareKey) {
    return decryptAES256GCM(encryptedData, shareKey);
  }

  /// 使用 PBKDF2 从密码派生密钥
  List<int> deriveKeyFromPassword(String password, List<int> salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(Uint8List.fromList(salt), 100000, 32));
    return pbkdf2.process(utf8.encode(password) as Uint8List);
  }

  /// 生成安全随机数
  SecureRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final seed = <int>[];
    final random = Random.secure();
    for (var i = 0; i < 32; i++) {
      seed.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seed)));
    return secureRandom;
  }

  /// 生成随机盐值
  List<int> generateSalt() {
    return _getSecureRandom().nextBytes(16);
  }
}
