import 'package:http/http.dart' as http;
import 'auth_http_client.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_registration_model.dart';
import '../config/app_config.dart';
import '../utils/secure_storage.dart';
import 'dart:convert';
import '../errors/errors.dart';

class UserService {
  final _client = AuthHttpClient();
  final String baseUrl = AppConfig.apiBaseUrl;

  Future<bool> registerUser(
    UserRegistrationModel user,
    BuildContext context,
  ) async {
    try {
      debugPrint('🔐 Contenido a insertar: ${jsonEncode(user.toJson())}');

      final response = await _client.post(
        Uri.parse('$baseUrl/user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      final jsonBody = jsonDecode(response.body);

      final result = Result.fromJson(
        jsonBody,
        (dataJson) => null, // En registro no esperas data
      );

      if (result.successful) {
        await showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text("✅ Registro exitoso"),
                content: Text("El usuario fue registrado correctamente."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
        );
        return true;
      } else {
        await showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 28),
                    SizedBox(width: 8),
                    Text("Error en el registro"),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      result.errors
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.brightness_1,
                                    size: 6,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(child: Text(e.message)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cerrar"),
                  ),
                ],
              ),
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error en el registro: $e');

      await showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("⚠️ Error inesperado"),
              content: Text(
                "Ocurrió un error al intentar registrar el usuario.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cerrar"),
                ),
              ],
            ),
      );

      return false;
    }
  }
}
