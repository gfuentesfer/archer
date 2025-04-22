import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveUsuario(User usuario) async {
    debugPrint('✅ Guardando token: ${usuario.token}');
    debugPrint('✅ Guardando refresh: ${usuario.refreshToken}');
    try {
      await _storage.write(key: 'access_token', value: usuario.token);
      await _storage.write(key: 'refresh_token', value: usuario.refreshToken);
      await _storage.write(
        key: 'token_expiry',
        value: usuario.tokenExpira.toIso8601String(),
      );
      await _storage.write(
        key: 'refresh_expiry',
        value: usuario.refreshExpira.toIso8601String(),
      );
      debugPrint('✔️ Tokens guardados correctamente');
    } catch (e) {
      debugPrint('❌ Error al guardar en SecureStorage: $e');
    }
  }

  static Future<String?> getAccessToken() async {
    final token = await _storage.read(key: 'access_token');
    debugPrint('🔎 Recuperado token: $token');
    return token;
  }

  static Future<String?> getRefreshToken() async =>
      await _storage.read(key: 'refresh_token');

  static Future<DateTime?> getTokenExpiry() async {
    final raw = await _storage.read(key: 'token_expiry');
    return raw != null ? DateTime.tryParse(raw) : null;
  }

  static Future<DateTime?> getRefreshExpiry() async {
    final raw = await _storage.read(key: 'refresh_expiry');
    return raw != null ? DateTime.tryParse(raw) : null;
  }

  //static Future<void> clear() async => await _storage.deleteAll();

  // Guardar tokens de acceso y refresh
  static Future<void> saveTokens(User user) async {
    await _storage.write(key: 'access_token', value: user.token);
    await _storage.write(key: 'refresh_token', value: user.refreshToken);
    await _storage.write(
      key: 'token_expiry',
      value: user.tokenExpira.toIso8601String(),
    );
    await _storage.write(
      key: 'refresh_expiry',
      value: user.refreshExpira.toIso8601String(),
    );
  }
}
