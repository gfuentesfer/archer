import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_registration_model.dart';
import '../services/user_service.dart';
import '../services/catalog_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final catalogService = CatalogService();
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  final nameController = TextEditingController();
  final familyNameController = TextEditingController();
  final emailController = TextEditingController();
  final dniController = TextEditingController();

  List<String> categories = [];
  List<String> modalities = [];
  List<String> roles = [];

  String? selectedCategory;
  String? selectedModality;
  String? selectedRole;

  DateTime? birthDate;
  DateTime? licenseDate;
  DateTime? inactiveAt;
  DateTime? blockedAt;

  bool hasClub = false;
  int? clubId;
  bool isActive = true;
  bool isBlocked = false;

  String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
  bool _loadingCatalogs = true;

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    try {
      categories = await catalogService.fetchCategories();
      modalities = await catalogService.fetchModalities();
      roles = await catalogService.fetchRoles();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar datos: $e')));
    } finally {
      setState(() => _loadingCatalogs = false);
    }
  }

  Future<void> _pickDate(
    BuildContext context,
    DateTime? currentDate,
    Function(DateTime) onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        birthDate != null &&
        licenseDate != null) {
      final user = UserRegistrationModel(
        licenseId: DateTime.now().millisecondsSinceEpoch,
        name: nameController.text,
        familyName: familyNameController.text,
        email: emailController.text,
        birthDate: _formatDate(birthDate!),
        dni: dniController.text,
        hasClub: hasClub,
        club: clubId ?? 0,
        licenseDate: _formatDate(licenseDate!),
        address: Address(
          street: 'Calle Ficticia',
          city: 'Ciudad',
          state: 'Provincia',
          country: 'España',
          zipCode: '00000',
          phone: '000000000',
          mobilePhone: '000000000',
        ),
        category: selectedCategory.toString(),
        modality: selectedModality.toString(),
        userRoles: selectedRole.toString(),
        isActive: isActive,
        inactiveAt: _formatDate(inactiveAt ?? DateTime.now()),
        createdAt: _formatDate(DateTime.now()),
        updatedAt: _formatDate(DateTime.now()),
        isBlocked: isBlocked,
        blockedAt: _formatDate(blockedAt ?? DateTime.now()),
      );

      try {
        final success = await UserService().registerUser(user);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Registro exitoso'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // 👈 Vuelve atrás
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ No se pudo registrar el usuario'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al registrar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Completa todos los campos obligatorios'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep == 2) {
              _submitForm();
            } else {
              setState(() => _currentStep += 1);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep -= 1);
          },
          steps: [step1(), step2(context), step3()],
        ),
      ),
    );
  }

  Step step3() {
    return Step(
      title: const Text('Estado y Club'),
      isActive: _currentStep >= 2,
      content:
          _loadingCatalogs
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // — Dropdown Categoría —
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      hintText: 'Selecciona una categoría',
                    ),
                    value:
                        selectedCategory, // El valor seleccionado de la categoría
                    items:
                        categories
                            .map(
                              (c) => DropdownMenuItem<String>(
                                value: c,
                                child: Text(c),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => selectedCategory = val),
                    validator:
                        (v) => v == null ? 'Selecciona una categoría' : null,
                  ),

                  const SizedBox(height: 12),

                  // — Dropdown Modalidad —
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Modalidad',
                      hintText: 'Selecciona una modalidad',
                    ),
                    value:
                        selectedModality, // El valor seleccionado de la modalidad
                    items:
                        modalities
                            .map(
                              (m) => DropdownMenuItem<String>(
                                value: m,
                                child: Text(m),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => selectedModality = val),
                    validator:
                        (v) => v == null ? 'Selecciona una modalidad' : null,
                  ),

                  const SizedBox(height: 12),

                  // — Dropdown Rol —
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Rol',
                      hintText: 'Selecciona un rol',
                    ),
                    value: selectedRole, // El valor seleccionado del rol
                    items:
                        roles
                            .map(
                              (r) => DropdownMenuItem<String>(
                                value: r,
                                child: Text(r),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => selectedRole = val),
                    validator: (v) => v == null ? 'Selecciona un rol' : null,
                  ),
                ],
              ),
    );
  }

  Step step2(BuildContext context) {
    return Step(
      title: const Text('Fechas'),
      isActive: _currentStep >= 1,
      content: Column(
        children: [
          ElevatedButton(
            onPressed:
                () => _pickDate(
                  context,
                  birthDate,
                  (d) => setState(() => birthDate = d),
                ),
            child: Text(
              birthDate == null
                  ? 'Seleccionar fecha nacimiento'
                  : 'Nacimiento: ${formatDate(birthDate!)}',
            ),
          ),
          ElevatedButton(
            onPressed:
                () => _pickDate(
                  context,
                  licenseDate,
                  (d) => setState(() => licenseDate = d),
                ),
            child: Text(
              licenseDate == null
                  ? 'Seleccionar fecha licencia'
                  : 'Licencia: ${formatDate(licenseDate!)}',
            ),
          ),
          ElevatedButton(
            onPressed:
                () => _pickDate(
                  context,
                  inactiveAt,
                  (d) => setState(() => inactiveAt = d),
                ),
            child: Text(
              inactiveAt == null
                  ? 'Seleccionar fecha inactivo'
                  : 'Inactivo desde: ${formatDate(inactiveAt!)}',
            ),
          ),
          ElevatedButton(
            onPressed:
                () => _pickDate(
                  context,
                  blockedAt,
                  (d) => setState(() => blockedAt = d),
                ),
            child: Text(
              blockedAt == null
                  ? 'Seleccionar fecha bloqueo'
                  : 'Bloqueado desde: ${formatDate(blockedAt!)}',
            ),
          ),
        ],
      ),
    );
  }

  Step step1() {
    return Step(
      title: const Text('Datos personales'),
      isActive: _currentStep >= 0,
      content: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
            validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
          ),
          TextFormField(
            controller: familyNameController,
            decoration: const InputDecoration(labelText: 'Apellido'),
            validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
          ),
          TextFormField(
            controller: dniController,
            decoration: const InputDecoration(labelText: 'DNI'),
            validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
