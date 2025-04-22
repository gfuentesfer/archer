import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart'; // Importamos la pantalla de registro
import '../screens/perfil_screen.dart'; // Si tienes esta pantalla
import 'auth_gate.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthGate(child: PerfilScreen()),
                ),
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
          // Otras opciones de menú (puedes agregar más aquí)
        ],
      ),
    );
  }
}
