import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class EditarPerfilScreen extends StatefulWidget {
  final Usuario usuario;

  const EditarPerfilScreen({required this.usuario, super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  late final TextEditingController _nombresController;
  late final TextEditingController _apellidosController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _correoController;
  late final TextEditingController _direccionController;

  final ImagePicker _picker = ImagePicker();
  bool _cargando = false;
  String? _imagenSeleccionada;

  @override
  void initState() {
    super.initState();
    _nombresController = TextEditingController(text: widget.usuario.nombres);
    _apellidosController = TextEditingController(text: widget.usuario.apellidos);
    _telefonoController = TextEditingController(text: widget.usuario.telefono);
    _correoController = TextEditingController(text: widget.usuario.correo ?? '');
    _direccionController = TextEditingController(text: widget.usuario.direccionExacta ?? '');
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFoto() async {
    final XFile? imagen = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (imagen != null) {
      setState(() => _imagenSeleccionada = imagen.path);
    }
  }

  Future<void> _guardarCambios() async {
    final lang = context.read<LanguageProvider>();
    if (_nombresController.text.isEmpty || _apellidosController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.translate('edit_profile_error_fields'))),
      );
      return;
    }

    setState(() => _cargando = true);
    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.actualizarPerfil(
            nombres: _nombresController.text.trim(),
            apellidos: _apellidosController.text.trim(),
            telefono: _telefonoController.text.trim(),
            correo: _correoController.text.trim().isEmpty ? null : _correoController.text.trim(),
            direccionExacta: _direccionController.text.trim(),
          );

      if (_imagenSeleccionada != null) {
        await authProvider.actualizarFotoPerfil(_imagenSeleccionada!);
      }

      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text(context.read<LanguageProvider>().translate('edit_profile_saved'))),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text('${context.read<LanguageProvider>().translate('profile_error')}$e')),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<LanguageProvider>().translate('edit_profile_title'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Foto de perfil
          Center(
            child: Stack(
              children: [
                _imagenSeleccionada != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(
                          File(_imagenSeleccionada!),
                        ),
                      )
                    : (widget.usuario.fotoPerfil != null &&
                            widget.usuario.fotoPerfil!.isNotEmpty
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(widget.usuario.fotoPerfil!),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.verdeMilpa,
                            child: Text(
                              widget.usuario.iniciales,
                              style: AppTextStyles.h1.copyWith(color: Colors.white),
                            ),
                          )),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _cargando ? null : _seleccionarFoto,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.verdeMilpa,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Nombres
          _buildTextField(
            label: context.watch<LanguageProvider>().translate('edit_profile_names'),
            controller: _nombresController,
            enabled: !_cargando,
          ),
          const SizedBox(height: 16),

          // Apellidos
          _buildTextField(
            label: context.watch<LanguageProvider>().translate('edit_profile_lastnames'),
            controller: _apellidosController,
            enabled: !_cargando,
          ),
          const SizedBox(height: 16),

          // Teléfono
          _buildTextField(
            label: context.watch<LanguageProvider>().translate('edit_profile_phone'),
            controller: _telefonoController,
            enabled: !_cargando,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          // Correo
          _buildTextField(
            label: context.watch<LanguageProvider>().translate('edit_profile_email'),
            controller: _correoController,
            enabled: !_cargando,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // Dirección
          _buildTextField(
            label: context.watch<LanguageProvider>().translate('edit_profile_address'),
            controller: _direccionController,
            enabled: !_cargando,
            maxLines: 2,
          ),
          const SizedBox(height: 32),

          // Botón guardar
          ElevatedButton(
            onPressed: _cargando ? null : _guardarCambios,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.verdeMilpa,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _cargando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Text(context.watch<LanguageProvider>().translate('edit_profile_save_changes')),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: maxLines == 1 ? 1 : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabled: enabled,
      ),
    );
  }
}
