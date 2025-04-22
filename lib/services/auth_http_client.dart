import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../utils/secure_storage.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final AuthService _authService = AuthService();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    String? accessToken = await SecureStorage.getAccessToken();

    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    final response = await _inner.send(request);

    // Si está expirado (401), intentamos refrescar
    if (response.statusCode == 401) {
      final newToken = await _authService.refreshAccessToken();
      if (newToken != null) {
        request.headers['Authorization'] = 'Bearer $newToken';
        return _inner.send(request); // reintenta con token nuevo
      }
    }

    return response;
  }
}
