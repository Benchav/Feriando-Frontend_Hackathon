import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/trueque.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trueque_provider.dart';
import '../../services/api_client.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/estado_badge.dart';

class TruequesScreen extends StatefulWidget {
  const TruequesScreen({super.key});

  @override
  State<TruequesScreen> createState() => _TruequesScreenState();
}

class _TruequesScreenState extends State<TruequesScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _formatoFecha = DateFormat('d MMM, h:mm a', 'es');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TruequeProvider>().cargarMios();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _responder(Trueque trueque, bool aceptar) async {
    try {
      await context.read<TruequeProvider>().responder(trueque.truequeID, aceptar: aceptar);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(aceptar ? 'Solicitud aceptada.' : 'Solicitud rechazada.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e is ApiException ? e.mensaje : 'No se pudo responder.')),
        );
      }
    }
  }

  Future<void> _valorar(Trueque trueque) async {
    int puntuacion = 5;
    final comentario = TextEditingController();
    try {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text('Valorar intercambio'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final valor = i + 1;
                    return IconButton(
                      icon: Icon(valor <= puntuacion ? Icons.star : Icons.star_border, color: AppColors.achiote),
                      onPressed: () => setStateDialog(() => puntuacion = valor),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: comentario,
                  decoration: const InputDecoration(labelText: 'Comentario (opcional)'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Enviar')),
            ],
          ),
        ),
      );

      if (confirmar != true || !mounted) return;
      try {
        await context.read<TruequeProvider>().valorar(
              truequeID: trueque.truequeID,
              puntuacion: puntuacion,
              comentario: comentario.text.trim().isEmpty ? null : comentario.text.trim(),
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Gracias por tu valoración!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e is ApiException ? e.mensaje : 'No se pudo enviar la valoración.')),
          );
        }
      }
    } finally {
      comentario.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioID = context.watch<AuthProvider>().usuario?.usuarioID ?? 0;
    final provider = context.watch<TruequeProvider>();

    final recibidas = provider.mios.where((t) => t.usuarioReceptorID == usuarioID).toList();
    final enviadas = provider.mios.where((t) => t.usuarioSolicitanteID == usuarioID).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis trueques'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Recibidas (${recibidas.length})'),
            Tab(text: 'Enviadas (${enviadas.length})'),
          ],
        ),
      ),
      body: provider.cargando && provider.mios.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.verdeMilpa))
          : TabBarView(
              controller: _tabController,
              children: [
                _lista(recibidas, esRecibida: true, usuarioID: usuarioID),
                _lista(enviadas, esRecibida: false, usuarioID: usuarioID),
              ],
            ),
    );
  }

  Widget _lista(List<Trueque> trueques, {required bool esRecibida, required int usuarioID}) {
    if (trueques.isEmpty) {
      return EmptyState(
        icono: Icons.sync_alt,
        titulo: esRecibida ? 'No has recibido solicitudes' : 'No has enviado solicitudes',
        mensaje: esRecibida
            ? 'Cuando alguien quiera uno de tus productos, aparecerá aquí.'
            : 'Explora el catálogo y solicita tu primer trueque.',
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<TruequeProvider>().cargarMios(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: trueques.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final t = trueques[i];
          final otraPersona = esRecibida ? t.usuarioSolicitanteNombre : t.usuarioReceptorNombre;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          t.productoSolicitadoNombre != null
                              ? '${t.productoOfertadoNombre} ⇄ ${t.productoSolicitadoNombre}'
                              : t.productoOfertadoNombre,
                          style: AppTextStyles.h3,
                        ),
                      ),
                      EstadoBadge(estado: t.estado),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Con: $otraPersona', style: AppTextStyles.caption),
                  Text(_formatoFecha.format(t.fechaSolicitud), style: AppTextStyles.caption),
                  if (t.lugarEncuentro != null && t.lugarEncuentro!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.place_outlined, size: 16, color: AppColors.verdeMilpa),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Punto de encuentro: ${t.lugarEncuentro}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textoPrimario,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (esRecibida && t.estado == 'Pendiente') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _responder(t, false),
                            child: const Text('Rechazar'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _responder(t, true),
                            child: const Text('Aceptar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (t.estado == 'Aceptado') ...[
                    const SizedBox(height: 12),
                    AppOutlineChip(
                      texto: 'Valorar intercambio',
                      onTap: () => _valorar(t),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppOutlineChip extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;
  const AppOutlineChip({super.key, required this.texto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.achiote),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_outline, size: 16, color: AppColors.achiote),
            const SizedBox(width: 6),
            Text(texto, style: AppTextStyles.etiqueta.copyWith(color: AppColors.achiote)),
          ],
        ),
      ),
    );
  }
}
