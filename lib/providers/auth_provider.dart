import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  User? _usuario;
  final AuthService _authService = AuthService();

  User? get usuario => _usuario;

  bool get isLoginIn => _usuario != null;

  Future<void> cargarUsuario() async {
    final token = await SecureStorage.getAccessToken();
    final refreshToken = await SecureStorage.getRefreshToken();
    final tokenExp = await SecureStorage.getTokenExpiry();
    final refreshExp = await SecureStorage.getRefreshExpiry();

    if (token != null &&
        refreshToken != null &&
        tokenExp != null &&
        refreshExp != null) {
      _usuario = User(
        userName: 'Desconocido', // Hasta que tengas un endpoint tipo /me
        token: token,
        refreshToken: refreshToken,
        tokenExpira: tokenExp,
        refreshExpira: refreshExp,
      );
    }

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final user = await _authService.login(email, password);
    if (user != null) {
      _usuario = user;
      notifyListeners();
    }
  }

  Future<void> verificarToken(BuildContext context) async {
    if (_usuario == null) return;

    final ahora = DateTime.now();
    final expira = _usuario!.tokenExpira;

    if (ahora.isBefore(expira)) return; // Todo ok

    // Si expiró, intentamos refrescar
    final nuevoUser = await _authService.renovarToken(_usuario!.refreshToken);
    if (nuevoUser != null) {
      _usuario = nuevoUser;
      notifyListeners();
      return;
    }

    // Si falló el refresh → cerrar sesión y mostrar mensaje
    logout();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tu sesión ha expirado. Inicia sesión nuevamente.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future<void> logout() async {
    //await SecureStorage.clear();
    _usuario = null;
    notifyListeners();
  }
}
