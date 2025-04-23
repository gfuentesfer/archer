import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../utils/secure_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/login_response.dart';

class AuthService {
  //static const _baseUrl = 'http://localhost:8085/api/v1/auth/login';
  //des emulador usa esta:
  static const _baseUrl = 'http://10.0.2.2:8085/api/v1'; // sin barra final

  Future<LoginResponse?> login(String userName, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userName': userName, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // data es Map<String, dynamic>
      final loginResponse = LoginResponse.fromJson(data);

      // Puedes guardar los tokens en SecureStorage si quieres
      await SecureStorage.saveUsuario(loginResponse.user);

      debugPrint('🪪 Token recibido: ${loginResponse.user.token}');
      return loginResponse;
    } else {
      return null;
    }
  }

  Future<String?> refreshAccessToken() async {
    final refreshToken = await SecureStorage.getRefreshToken();
    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse('$_baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final usuario = User.fromJson(data);
      await SecureStorage.saveUsuario(usuario);
      return usuario.token;
    } else {
      //await SecureStorage.clear();
      return null;
    }
  }

  Future<bool> isTokenExpired() async {
    final exp = await SecureStorage.getTokenExpiry();
    if (exp == null) return true;
    return DateTime.now().isAfter(exp);
  }

  Future<bool> isRefreshTokenExpired() async {
    final exp = await SecureStorage.getRefreshExpiry();
    if (exp == null) return true;
    return DateTime.now().isAfter(exp);
  }

  Future<User?> renovarToken(String refreshToken) async {
    final url = Uri.parse('$_baseUrl/auth/refresh'); // ajustalo a tu backend
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data);
      await SecureStorage.saveUsuario(user);
      return user;
    }

    return null;
  }
}
