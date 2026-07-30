import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>().usuario;

    // Construir la cadena con el municipio y departamento
    String ubicacionGeografica = '';
    if (usuario?.municipio != null && usuario?.departamento != null) {
      ubicacionGeografica = '${usuario!.municipio}, ${usuario.departamento}';
    } else if (usuario?.departamento != null) {
      ubicacionGeografica = usuario!.departamento!;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: usuario == null
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.verdeMilpa,
                        child: Text(
                          usuario.iniciales,
                          style: AppTextStyles.h1.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(usuario.nombreCompleto, style: AppTextStyles.h2),
                      if (ubicacionGeografica.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.textoSecundario,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ubicacionGeografica,
                              style: AppTextStyles.cuerpo.copyWith(color: AppColors.textoSecundario),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: AppColors.achiote, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            usuario.promedioValoracion.toStringAsFixed(1),
                            style: AppTextStyles.cuerpoDestacado,
                          ),
                          Text(' de confianza', style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                _filaInfo(Icons.phone_outlined, 'Teléfono', usuario.telefono),
                if (usuario.correo != null && usuario.correo!.isNotEmpty)
                  _filaInfo(Icons.mail_outline, 'Correo', usuario.correo!),
                if (usuario.departamento != null)
                  _filaInfo(Icons.map_outlined, 'Departamento', usuario.departamento!),
                if (usuario.municipio != null)
                  _filaInfo(Icons.location_city_outlined, 'Municipio', usuario.municipio!),
                _filaInfo(
                  Icons.storefront_outlined,
                  'Perfil',
                  usuario.esProductora ? 'Productora' : 'Compradora',
                ),
                const SizedBox(height: 28),
                OutlinedButton.icon(
                  onPressed: () => context.read<AuthProvider>().logout(),
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text('Cerrar sesión', style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _filaInfo(IconData icono, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: AppColors.textoSecundario, size: 20),
          const SizedBox(width: 12),
          Text(etiqueta, style: AppTextStyles.etiqueta),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: AppTextStyles.cuerpoDestacado,
            ),
          ),
        ],
      ),
    );
  }
}