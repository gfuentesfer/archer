import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart'; // Importamos la pantalla de registro
import '../screens/perfil_screen.dart'; // Si tienes esta pantalla
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // o la ruta correcta según tu estructura

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Menú')),
          // Opción para "Cerrar sesión"
          ListTile(
            title: const Text('Cerrar sesión'),
            onTap: () {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              authProvider.logout(); // <- cerramos la sesión

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ), // <-- o AuthGate si gestiona login
                (route) => false,
              );
            },
          ),
          // Opción para "Registro de Usuario"
          ListTile(
            title: const Text('Registro de Usuario'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Perfil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilScreen()),
              );
            },
          ),
          // Otras opciones de menú (puedes agregar más aquí)
        ],
      ),
    );
  }
}
