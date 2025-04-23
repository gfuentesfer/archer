import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Auth App',
        debugShowCheckedModeBanner:
            false, // para activar o quitar la banderia de debug
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed:
              Colors.deepPurple, // Cambia esto si prefieres otro color
          brightness:
              Brightness
                  .light, // O usa Brightness.dark si prefieres modo oscuro
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
