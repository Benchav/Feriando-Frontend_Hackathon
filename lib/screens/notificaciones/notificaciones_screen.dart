import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/trueque.dart';
import '../../services/notificacion_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/empty_state.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  final NotificacionService _service = NotificacionService();
  final _formatoFecha = DateFormat('d MMM, h:mm a', 'es');
  List<Notificacion> _notificaciones = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final datos = await _service.listar();
      if (!mounted) return;
      setState(() {
        _notificaciones = datos;
        _cargando = false;
      });
    } catch (_) {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _marcarLeida(Notificacion n) async {
    if (n.leido) return;
    try {
      await _service.marcarLeida(n.notificacionID);
      await _cargar();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo actualizar la notificacion.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: AppColors.verdeMilpa))
          : _notificaciones.isEmpty
              ? const EmptyState(
                  icono: Icons.notifications_none,
                  titulo: 'Sin notificaciones',
                  mensaje: 'Aquí verás avisos sobre tus solicitudes de trueque.',
                )
              : RefreshIndicator(
                  onRefresh: _cargar,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notificaciones.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final n = _notificaciones[i];
                      return InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _marcarLeida(n),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: n.leido ? AppColors.superficie : AppColors.verdeMilpaSuave,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borde),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                n.leido ? Icons.notifications_outlined : Icons.notifications_active,
                                color: n.leido ? AppColors.textoSecundario : AppColors.verdeMilpa,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(n.titulo, style: AppTextStyles.cuerpoDestacado),
                                    const SizedBox(height: 2),
                                    Text(n.mensaje, style: AppTextStyles.cuerpo),
                                    const SizedBox(height: 4),
                                    Text(_formatoFecha.format(n.fechaCreacion), style: AppTextStyles.caption),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
