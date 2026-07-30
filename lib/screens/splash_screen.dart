import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().cargarSesionGuardada();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.estado == EstadoSesion.cargando) {
      return const Scaffold(
        backgroundColor: AppColors.verdeMilpa,
        body: Center(
          child: Icon(Icons.sync_alt_rounded, color: Colors.white, size: 56),
        ),
      );
    }
    return auth.estado == EstadoSesion.autenticada ? const HomeScreen() : const LoginScreen();
  }
}
