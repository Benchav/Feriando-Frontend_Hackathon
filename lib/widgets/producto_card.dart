import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'estado_badge.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;

  const ProductoCard({super.key, required this.producto, required this.onTap});

  IconData get _iconoCategoria {
    switch (producto.categoria) {
      case 'Semillas':
        return Icons.eco_outlined;
      case 'Alimentos':
        return Icons.restaurant_outlined;
      case 'Artesanías':
        return Icons.palette_outlined;
      case 'Textiles':
        return Icons.checkroom_outlined;
      default:
        return Icons.storefront_outlined;
    }
  }

  String get _ubicacionTexto {
    if (producto.municipio.isNotEmpty && producto.departamento.isNotEmpty) {
      return '${producto.municipio}, ${producto.departamento}';
    }
    return producto.departamento.isNotEmpty ? producto.departamento : producto.municipio;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.verdeMilpaSuave,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_iconoCategoria, color: AppColors.verdeMilpa, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: AppTextStyles.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${producto.nombreProductora} · $_ubicacionTexto',
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        EstadoBadge(estado: producto.estado),
                        const SizedBox(width: 6),
                        Text(producto.tipoOferta, style: AppTextStyles.etiqueta),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}