import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../models/user_registration_model.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'token';
  static const _keyRefresh = 'refreshToken';
  static const _keyTokenExp = 'tokenExp';
  static const _keyRefreshExp = 'refreshExp';
  static const _keyUserProfile = 'userProfile'; // ✅ NUEVO

  static Future<void> saveUsuario(User user) async {
    await _storage.write(key: _keyToken, value: user.token);
    await _storage.write(key: _keyRefresh, value: user.refreshToken);
    await _storage.write(
      key: _keyTokenExp,
      value: user.tokenExpira.toIso8601String(),
    );
    await _storage.write(
      key: _keyRefreshExp,
      value: user.refreshExpira.toIso8601String(),
    );
  }

  static Future<void> saveUserProfile(UserRegistrationModel profile) async {
    final jsonString = jsonEncode(profile.toJson());
    await _storage.write(key: _keyUserProfile, value: jsonString);
  }

  static Future<UserRegistrationModel?> getUserProfile() async {
    final jsonString = await _storage.read(key: _keyUserProfile);
    if (jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString);
    return UserRegistrationModel.fromJson(jsonMap);
  }

  static Future<String?> getAccessToken() => _storage.read(key: _keyToken);
  static Future<String?> getRefreshToken() => _storage.read(key: _keyRefresh);

  static Future<DateTime?> getTokenExpiry() async {
    final value = await _storage.read(key: _keyTokenExp);
    return value != null ? DateTime.parse(value) : null;
  }

  static Future<DateTime?> getRefreshExpiry() async {
    final value = await _storage.read(key: _keyRefreshExp);
    return value != null ? DateTime.parse(value) : null;
  }

  static Future<void> clear() async => await _storage.deleteAll();
}
