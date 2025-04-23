import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // o la ruta correcta según tu estructura

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  String _error = '';

  void _login() async {
    final loginResponse = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (loginResponse != null) {
      // Guardar en el AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setUsuarioCompleto(
        loginResponse.user,
        loginResponse.profile,
      );

      debugPrint('✅ Usuario logueado. Token: ${loginResponse.user.token}');

      // Navegación
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() => _error = 'Login fallido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(onPressed: _login, child: const Text('Entrar')),
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
