import 'package:flutter/material.dart';
import '../utils/secure_storage.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _printToken();
  }

  void _printToken() async {
    final token = await SecureStorage.getAccessToken();
    debugPrint('📦 Token desde SecureStorage en HomeScreen: $token');
  }

  void _logout(BuildContext context) async {
    //  await SecureStorage.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('¡Bienvenido!')),
    );
  }
}
