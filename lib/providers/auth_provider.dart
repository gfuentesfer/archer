import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/user_registration_model.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';
import '../utils/secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  User? _usuario;
  UserRegistrationModel? _usuarioPerfil;
  final AuthService _authService = AuthService();

  User? get usuario => _usuario;
  UserRegistrationModel? get usuarioPerfil => _usuarioPerfil;

  bool get isLoginIn => _usuario != null;

  /// Cargar desde almacenamiento seguro (persistencia local)
  Future<void> cargarUsuario() async {
    final token = await SecureStorage.getAccessToken();
    final refreshToken = await SecureStorage.getRefreshToken();
    final tokenExp = await SecureStorage.getTokenExpiry();
    final refreshExp = await SecureStorage.getRefreshExpiry();
    final perfil = await SecureStorage.getUserProfile(); // ✅ Nuevo

    if (token != null &&
        refreshToken != null &&
        tokenExp != null &&
        refreshExp != null) {
      _usuario = User(
        userName: 'Desconocido', // o usa un endpoint /me para obtenerlo
        token: token,
        refreshToken: refreshToken,
        tokenExpira: tokenExp,
        refreshExpira: refreshExp,
      );
      _usuarioPerfil = perfil;
    }

    notifyListeners();
  }

  /// Login que usa LoginResponse
  Future<void> login(String email, String password) async {
    final response = await _authService.login(email, password);

    if (response != null) {
      setUsuarioCompleto(response.user, response.profile);
    }
  }

  /// Refresca el token si ha expirado
  Future<void> verificarToken(BuildContext context) async {
    if (_usuario == null) return;

    final ahora = DateTime.now();
    final expira = _usuario!.tokenExpira;

    if (ahora.isBefore(expira)) return;

    final nuevoUser = await _authService.renovarToken(_usuario!.refreshToken);
    if (nuevoUser != null) {
      _usuario = nuevoUser;
      notifyListeners();
      return;
    }

    logout();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tu sesión ha expirado. Inicia sesión nuevamente.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  /// Cerrar sesión
  Future<void> logout() async {
    _usuario = null;
    _usuarioPerfil = null;
    await SecureStorage.clear();
    notifyListeners();
  }

  /// Guardar ambos: usuario con tokens y perfil
  void setUsuarioCompleto(User user, UserRegistrationModel perfil) {
    _usuario = user;
    _usuarioPerfil = perfil;

    SecureStorage.saveUsuario(user);
    SecureStorage.saveUserProfile(perfil); // ✅ Guardamos el perfil

    notifyListeners();
  }
}
