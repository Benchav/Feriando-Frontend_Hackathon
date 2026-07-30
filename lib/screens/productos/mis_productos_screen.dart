import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/producto.dart';
import '../../providers/producto_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/estado_badge.dart';
import 'publicar_producto_screen.dart';

class MisProductosScreen extends StatefulWidget {
  const MisProductosScreen({super.key});

  @override
  State<MisProductosScreen> createState() => _MisProductosScreenState();
}

class _MisProductosScreenState extends State<MisProductosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductoProvider>().cargarMios();
    });
  }

  Future<void> _confirmarEliminar(Producto producto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Seguro que quieres eliminar "${producto.nombre}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      await context.read<ProductoProvider>().eliminar(producto.productoID);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado.')),
        );
      }
    }
  }

  String _obtenerUbicacionTexto(Producto producto) {
    if (producto.municipio.isNotEmpty && producto.departamento.isNotEmpty) {
      return '${producto.municipio}, ${producto.departamento}';
    }
    if (producto.municipio.isNotEmpty) {
      return producto.municipio;
    }
    return producto.departamento.isNotEmpty ? producto.departamento : '';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis productos')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.achiote,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Publicar', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PublicarProductoScreen()),
          );
          if (mounted) context.read<ProductoProvider>().cargarMios();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.cargarMios(),
        child: provider.cargando && provider.misProductos.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppColors.verdeMilpa))
            : provider.misProductos.isEmpty
                ? const EmptyState(
                    icono: Icons.inventory_2_outlined,
                    titulo: 'Aún no has publicado nada',
                    mensaje: 'Toca "Publicar" para ofrecer tu primer producto en trueque.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                    itemCount: provider.misProductos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final producto = provider.misProductos[i];
                      final ubicacion = _obtenerUbicacionTexto(producto);

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(producto.nombre, style: AppTextStyles.h3)),
                                  EstadoBadge(estado: producto.estado),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${producto.cantidad} ${producto.unidadMedida} · ${producto.tipoOferta}',
                                style: AppTextStyles.caption,
                              ),
                              if (ubicacion.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: AppColors.textoSecundario,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        ubicacion,
                                        style: AppTextStyles.caption.copyWith(color: AppColors.textoSecundario),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  TextButton.icon(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    label: const Text('Editar'),
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => PublicarProductoScreen(productoExistente: producto),
                                        ),
                                      );
                                      if (mounted) context.read<ProductoProvider>().cargarMios();
                                    },
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                    label: const Text('Eliminar', style: TextStyle(color: AppColors.error)),
                                    onPressed: () => _confirmarEliminar(producto),
                                  ),
                                ],
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