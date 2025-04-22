import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/secure_storage.dart';

class ApiClient {
  static Future<http.Response> get(String url) async {
    final token = await SecureStorage.getAccessToken();

    return http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<http.Response> post(String url, dynamic body) async {
    final token = await SecureStorage.getAccessToken();

    return http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  // También puedes crear métodos put, delete, etc.
}
