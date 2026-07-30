import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String mensaje;
  final Widget? accion;

  const EmptyState({
    super.key,
    required this.icono,
    required this.titulo,
    required this.mensaje,
    this.accion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56, color: AppColors.textoSecundario),
            const SizedBox(height: 16),
            Text(titulo, style: AppTextStyles.h3, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(mensaje, style: AppTextStyles.cuerpo.copyWith(color: AppColors.textoSecundario), textAlign: TextAlign.center),
            if (accion != null) ...[const SizedBox(height: 20), accion!],
          ],
        ),
      ),
    );
  }
}
