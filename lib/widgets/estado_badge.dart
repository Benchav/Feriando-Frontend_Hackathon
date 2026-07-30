import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class EstadoBadge extends StatelessWidget {
  final String estado;
  const EstadoBadge({super.key, required this.estado});

  Color get _color {
    switch (estado) {
      case 'Disponible':
        return AppColors.verdeMilpa;
      case 'Reservado':
      case 'Pendiente':
        return AppColors.achiote;
      case 'Intercambiado':
      case 'Completado':
      case 'Aceptado':
        return AppColors.anil;
      case 'Rechazado':
      case 'Cancelado':
        return AppColors.error;
      default:
        return AppColors.textoSecundario;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(20)),
      child: Text(estado, style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }
}
