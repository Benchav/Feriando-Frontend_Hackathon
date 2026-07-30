import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/producto.dart';
import '../../providers/producto_provider.dart';
import '../../providers/trueque_provider.dart';
import '../../services/api_client.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class SolicitarTruequeScreen extends StatefulWidget {
  final Producto productoDeseado;
  const SolicitarTruequeScreen({super.key, required this.productoDeseado});

  @override
  State<SolicitarTruequeScreen> createState() => _SolicitarTruequeScreenState();
}

class _SolicitarTruequeScreenState extends State<SolicitarTruequeScreen> {
  final _lugar = TextEditingController();
  Producto? _productoOfrecido;
  bool _esCompra = false; // si no ofrece nada a cambio (venta/solicitud directa)
  bool _cargandoMios = true;
  bool _enviando = false;
  List<Producto> _misProductos = [];

  @override
  void initState() {
    super.initState();
    _cargarMisProductos();
    _sugerirLugarInicial();
  }

  void _sugerirLugarInicial() {
    final dep = widget.productoDeseado.departamento;
    final mun = widget.productoDeseado.municipio;
    if (mun.isNotEmpty && dep.isNotEmpty) {
      _lugar.text = 'Centro de $mun, $dep';
    } else if (dep.isNotEmpty) {
      _lugar.text = 'Punto céntrico en $dep';
    }
  }

  Future<void> _cargarMisProductos() async {
    final provider = context.read<ProductoProvider>();
    await provider.cargarMios();
    if (!mounted) return;
    setState(() {
      _misProductos = provider.misProductos.where((p) => p.estado == 'Disponible').toList();
      _cargandoMios = false;
    });
  }

  Future<void> _enviarSolicitud() async {
    if (!_esCompra && _productoOfrecido == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elige qué producto vas a ofrecer.')),
      );
      return;
    }

    setState(() => _enviando = true);
    try {
      await context.read<TruequeProvider>().solicitar(
            productoOfertadoID: _esCompra ? widget.productoDeseado.productoID : _productoOfrecido!.productoID,
            productoSolicitadoID: _esCompra ? null : widget.productoDeseado.productoID,
            lugarEncuentro: _lugar.text.trim().isEmpty ? null : _lugar.text.trim(),
          );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud enviada. Espera la respuesta de la productora.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e is ApiException ? e.mensaje : 'No se pudo enviar la solicitud.')),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  String _obtenerUbicacionTexto(Producto p) {
    if (p.municipio.isNotEmpty && p.departamento.isNotEmpty) {
      return '${p.municipio}, ${p.departamento}';
    }
    return p.departamento.isNotEmpty ? p.departamento : '';
  }

  @override
  Widget build(BuildContext context) {
    final permiteVenta = widget.productoDeseado.tipoOferta != 'Trueque';
    final ubicacionDeseada = _obtenerUbicacionTexto(widget.productoDeseado);

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar intercambio')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.verdeMilpaSuave,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.storefront, color: AppColors.verdeMilpa),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Vas a solicitar: ${widget.productoDeseado.nombre}',
                          style: AppTextStyles.cuerpoDestacado,
                        ),
                      ),
                    ],
                  ),
                  if (ubicacionDeseada.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: AppColors.verdeMilpa),
                        const SizedBox(width: 6),
                        Text(
                          'Ubicación: $ubicacionDeseada',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (permiteVenta)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _esCompra,
                onChanged: (v) => setState(() => _esCompra = v),
                activeThumbColor: AppColors.verdeMilpa,
                title: const Text('Comprar directamente'),
                subtitle: const Text('En vez de ofrecer un producto a cambio'),
              ),
            if (!_esCompra) ...[
              Text('¿Qué producto ofreces a cambio?', style: AppTextStyles.etiqueta),
              const SizedBox(height: 8),
              _cargandoMios
                  ? const Center(child: CircularProgressIndicator(color: AppColors.verdeMilpa))
                  : _misProductos.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'No tienes productos disponibles. Publica uno primero desde "Mis productos".',
                            style: AppTextStyles.cuerpo.copyWith(color: AppColors.textoSecundario),
                          ),
                        )
                      : Column(
                          children: _misProductos.map((p) {
                            final ubicacionPropia = _obtenerUbicacionTexto(p);
                            return RadioListTile<Producto>(
                              contentPadding: EdgeInsets.zero,
                              value: p,
                              groupValue: _productoOfrecido,
                              activeColor: AppColors.verdeMilpa,
                              title: Text(p.nombre),
                              subtitle: Text(
                                '${p.cantidad} ${p.unidadMedida}${ubicacionPropia.isNotEmpty ? ' · $ubicacionPropia' : ''}',
                              ),
                              onChanged: (v) => setState(() => _productoOfrecido = v),
                            );
                          }).toList(),
                        ),
            ],
            const SizedBox(height: 14),
            AppTextField(
              etiqueta: 'Lugar de encuentro sugerido',
              controller: _lugar,
              icono: Icons.place_outlined,
            ),
            const SizedBox(height: 28),
            AppButton(
              texto: 'Enviar solicitud',
              onPressed: _enviarSolicitud,
              cargando: _enviando,
            ),
          ],
        ),
      ),
    );
  }
}
