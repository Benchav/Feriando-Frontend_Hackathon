import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_client.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _telefono = TextEditingController();
  final _password = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _telefono.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _cargando = true);
    try {
      await context.read<AuthProvider>().login(_telefono.text.trim(), _password.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e is ApiException ? e.mensaje : 'No se pudo iniciar sesión.')),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 48),
                Container(
                  width: 84, 
                  height: 84, 
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: AppColors.verdeMilpa, shape: BoxShape.circle),
                  child: const Icon(Icons.sync_alt_rounded, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                Text('El Trueque', style: AppTextStyles.h1, textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text(
                  'Intercambio con enfoque de género',
                  style: AppTextStyles.cuerpo.copyWith(color: AppColors.textoSecundario),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                AppTextField(
                  etiqueta: 'Número de teléfono',
                  controller: _telefono,
                  tipoTeclado: TextInputType.phone,
                  icono: Icons.phone_outlined,
                  validador: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tu número de teléfono' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  etiqueta: 'Contraseña',
                  controller: _password,
                  esPassword: true,
                  icono: Icons.lock_outline,
                  validador: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 24),
                AppButton(texto: 'Iniciar sesión', onPressed: _iniciarSesion, cargando: _cargando),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegistroScreen()),
                  ),
                  child: Text(
                    '¿No tienes cuenta? Regístrate',
                    style: AppTextStyles.cuerpoDestacado.copyWith(color: AppColors.verdeMilpa),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}