import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa el paquete provider
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart'; // Asegúrate de importar tu AuthProvider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Aquí envolvemos la aplicación con el Provider
      create: (context) => AuthProvider(), // Proveemos el AuthProvider
      child: MaterialApp(
        title: 'Auth App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(), // O la pantalla que desees como home
      ),
    );
  }
}
