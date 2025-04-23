import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_registration_model.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).usuarioPerfil;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Usuario'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section("🧑 Información personal", [
              _infoTile("Nombre", "${user.name} ${user.familyName}"),
              _infoTile("Email", user.email),
              _infoTile("DNI", user.dni),
              _infoTile("Fecha de nacimiento", user.birthDate),
            ]),
            _section("📋 Detalles de licencia", [
              _infoTile("ID Licencia", user.licenseId.toString()),
              _infoTile("Fecha de licencia", user.licenseDate),
              _infoTile("Categoría", user.category),
              _infoTile("Modalidad", user.modality),
              _infoTile(
                "Club asociado",
                user.hasClub ? "Sí (${user.club})" : "No",
              ),
            ]),
            _section("🏠 Dirección", [
              _infoTile("Calle", user.address.street),
              _infoTile("Ciudad", user.address.city),
              _infoTile("Estado", user.address.state),
              _infoTile("País", user.address.country),
              _infoTile("Código Postal", user.address.zipCode),
              _infoTile("Teléfono fijo", user.address.phone),
              _infoTile("Teléfono móvil", user.address.mobilePhone),
            ]),
            _section("🔐 Seguridad y Estado", [
              _infoTile("Roles", user.userRoles),
              _infoTile("Activo", user.isActive ? "Sí" : "No"),
              if (!user.isActive) _infoTile("Inactivo desde", user.inactiveAt),
              _infoTile("Bloqueado", user.isBlocked ? "Sí" : "No"),
              if (user.isBlocked) _infoTile("Bloqueado desde", user.blockedAt),
              _infoTile("Creado el", user.createdAt),
              _infoTile("Última actualización", user.updatedAt),
            ]),
            const SizedBox(height: 24),
            Center(
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar ventana'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> tiles) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...tiles,
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
