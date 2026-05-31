import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import 'encryption_service.dart';

/// 密钥管理服务
/// 管理设备主密钥和分享密钥
/// 使用 iOS Keychain / Android Keystore 安全存储
class KeyManager {
  KeyManager._();

  static final KeyManager _instance = KeyManager._();

  factory KeyManager() => _instance;

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accountName: 'com.aiopc.stream',
    ),
  );

  static const _mainKeyTag = 'ai_opc_main_key';
  static const _deviceIdTag = 'ai_opc_device_id';

  /// 获取或生成设备主密钥（32字节）
  /// 用于本地数据库加密和项目数据加密
  Future<List<int>> getMainKey() async {
    final stored = await _storage.read(key: _mainKeyTag);
    if (stored != null) {
      return base64.decode(stored);
    }

    // 生成新密钥
    final newKey = EncryptionService().generateShareKey();
    await _storage.write(
      key: _mainKeyTag,
      value: base64.encode(newKey),
    );
    return newKey;
  }

  /// 获取或生成设备唯一 ID
  Future<String> getDeviceId() async {
    final stored = await _storage.read(key: _deviceIdTag);
    if (stored != null) {
      return stored;
    }

    final deviceId = const Uuid().v4();
    await _storage.write(key: _deviceIdTag, value: deviceId);
    return deviceId;
  }

  /// 为指定项目生成项目主密钥（32字节）
  /// 项目主密钥用于加密该项目下的成员权限信息和操作日志
  Future<List<int>> getProjectKey(String projectId) async {
    final tag = 'proj_key_$projectId';
    final stored = await _storage.read(key: tag);
    if (stored != null) {
      return base64.decode(stored);
    }

    final newKey = EncryptionService().generateShareKey();
    await _storage.write(
      key: tag,
      value: base64.encode(newKey),
    );
    return newKey;
  }

  /// 删除项目密钥（项目归档或删除时）
  Future<void> deleteProjectKey(String projectId) async {
    final tag = 'proj_key_$projectId';
    await _storage.delete(key: tag);
  }

  /// 从分享 URL 哈希中解析分享密钥
  /// URL 格式: https://app.aiopc.com/share#base64key
  static List<int> parseShareKeyFromUrl(String urlHash) {
    // 移除 # 号
    final keyStr = urlHash.startsWith('#') ? urlHash.substring(1) : urlHash;
    return base64.decode(keyStr);
  }

  /// 生成分享 URL（密钥放在哈希中）
  static String generateShareUrl(String shareId, List<int> shareKey) {
    final keyStr = base64.encode(shareKey);
    return 'https://app.aiopc.com/share/$shareId#$keyStr';
  }

  /// 清除所有密钥（生物识别失败5次后调用）
  Future<void> clearAllKeys() async {
    await _storage.deleteAll();
  }

  /// 检查是否设置了生物识别保护
  Future<bool> isBiometricEnabled() async {
    final stored = await _storage.read(key: 'biometric_enabled');
    return stored == 'true';
  }

  /// 设置生物识别保护
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: 'biometric_enabled',
      value: enabled.toString(),
    );
  }

  /// 读取任意 key（用于读取 API Key 等）
  Future<String?> readValue(String key) async {
    return _storage.read(key: key);
  }

  /// 写入任意 key（用于写入 API Key 等）
  Future<void> writeValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
}
