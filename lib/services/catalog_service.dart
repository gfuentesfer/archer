import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart'; // 👈 Importa la config
import 'auth_http_client.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/secure_storage.dart'; // Asegúrate de importar correctamente

class CatalogService {
  final _client = AuthHttpClient();
  final String baseUrl = AppConfig.apiBaseUrl;

  @override
  void initState() {
    checkAccessToken();
  }

  Future<List<String>> fetchCategories() async {
    debugPrint('📡 Llamando a $baseUrl/categories');
    final token = await SecureStorage.getAccessToken();
    debugPrint('🔐 Token antes de llamar al endpoint: $token');

    final response = await _client.get(
      Uri.parse('$baseUrl/categories'),
      headers: {'Accept': 'application/json'},
    );
    debugPrint('📡 fetchCategories status: ${response.statusCode}');
    debugPrint('📡 fetchCategories headers: ${response.headers}');
    debugPrint('📡 fetchCategories body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<String>();
    } else {
      throw Exception('No se pudieron cargar las categorías');
    }
  }

  Future<List<String>> fetchModalities() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/modalities'),
      headers: {
        'Accept': 'application/json', // aquí le decimos que queremos JSON
        // Authorization ya lo añade tu AuthHttpClient internamente
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<String>();
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<String>> fetchRoles() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/roles'),
      headers: {
        'Accept': 'application/json', // aquí le decimos que queremos JSON
        // Authorization ya lo añade tu AuthHttpClient internamente
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<String>();
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  void checkAccessToken() async {
    final token = await SecureStorage.getAccessToken();
    debugPrint('🔐 Token recuperado desde SecureStorage: $token');
  }
}
