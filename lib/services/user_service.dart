import 'package:http/http.dart' as http;
import 'auth_http_client.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_registration_model.dart';
import '../config/app_config.dart';
import '../utils/secure_storage.dart';
import 'dart:convert';

class UserService {
  final _client = AuthHttpClient();
  final String baseUrl = AppConfig.apiBaseUrl;

  Future<bool> registerUser(UserRegistrationModel user) async {
    try {
      final token = await SecureStorage.getAccessToken();
      debugPrint('🔐 Contenido a insertar: ' + jsonEncode(user.toJson()));
      final response = await _client.post(
        Uri.parse('$baseUrl/user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        // Si el registro es exitoso
        return true;
      } else {
        // Si algo falla, muestra un mensaje con el error
        throw Exception('Error en el registro: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error en el registro: $e');
      throw Exception('Error en el registro: $e');
    }
  }
}
