import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final bool cargando;
  final bool secundario;
  final IconData? icono;

  const AppButton({
    super.key,
    required this.texto,
    required this.onPressed,
    this.cargando = false,
    this.secundario = false,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    final contenido = cargando
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icono != null) ...[Icon(icono, size: 20), const SizedBox(width: 8)],
              Text(texto),
            ],
          );

    if (secundario) {
      return OutlinedButton(onPressed: cargando ? null : onPressed, child: contenido);
    }
    return ElevatedButton(
      onPressed: cargando ? null : onPressed,
      style: ElevatedButton.styleFrom(disabledBackgroundColor: AppColors.verdeMilpa.withValues(alpha: 0.6)),
      child: contenido,
    );
  }
}
