import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/producto.dart';
import '../../providers/auth_provider.dart';
import '../../services/producto_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/estado_badge.dart';
import '../trueques/solicitar_trueque_screen.dart';

class DetalleProductoScreen extends StatefulWidget {
  final int productoID;
  const DetalleProductoScreen({super.key, required this.productoID});

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  final ProductoService _service = ProductoService();
  Producto? _producto;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final producto = await _service.obtener(widget.productoID);
      if (!mounted) return;
      setState(() {
        _producto = producto;
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioActualID = context.read<AuthProvider>().usuario?.usuarioID;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del producto')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: AppColors.verdeMilpa))
          : _producto == null
              ? const Center(child: Text('No se encontró el producto.'))
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            Container(
                              height: 180,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.verdeMilpaSuave,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.storefront, size: 64, color: AppColors.verdeMilpa),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(child: Text(_producto!.nombre, style: AppTextStyles.h1)),
                                EstadoBadge(estado: _producto!.estado),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_producto!.cantidad} ${_producto!.unidadMedida} · ${_producto!.categoria}',
                              style: AppTextStyles.cuerpoDestacado.copyWith(color: AppColors.textoSecundario),
                            ),
                            const SizedBox(height: 16),
                            if (_producto!.descripcion != null && _producto!.descripcion!.isNotEmpty) ...[
                              Text('Descripción', style: AppTextStyles.etiqueta),
                              const SizedBox(height: 4),
                              Text(_producto!.descripcion!, style: AppTextStyles.cuerpo),
                              const SizedBox(height: 16),
                            ],
                            
                            // Tarjeta de Información del Productor y Ubicación
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.superficie,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.borde),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColors.anil,
                                        child: Icon(Icons.person, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_producto!.nombreProductora, style: AppTextStyles.cuerpoDestacado),
                                            Text('Productor(a)', style: AppTextStyles.caption),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 20, color: AppColors.verdeMilpa),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${_producto!.municipio}, ${_producto!.departamento}',
                                              style: AppTextStyles.cuerpoDestacado,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: [
                                Chip(label: Text('Oferta: ${_producto!.tipoOferta}')),
                                if (_producto!.precioReferencial != null)
                                  Chip(label: Text('C\$ ${_producto!.precioReferencial!.toStringAsFixed(0)}')),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (_producto!.estado == 'Disponible' && _producto!.usuarioID != usuarioActualID)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: AppButton(
                            texto: 'Solicitar trueque',
                            icono: Icons.sync_alt,
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SolicitarTruequeScreen(productoDeseado: _producto!),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
