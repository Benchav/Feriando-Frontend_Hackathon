import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/catalogos.dart';
import '../../models/producto.dart';
import '../../providers/producto_provider.dart';
import '../../services/api_client.dart';
import '../../services/catalogo_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

/// Un solo formulario para las dos operaciones:
/// - productoExistente == null  -> CREATE (POST /api/productos)
/// - productoExistente != null  -> UPDATE (PUT /api/productos/{id})
class PublicarProductoScreen extends StatefulWidget {
  final Producto? productoExistente;
  const PublicarProductoScreen({super.key, this.productoExistente});

  bool get esEdicion => productoExistente != null;

  @override
  State<PublicarProductoScreen> createState() => _PublicarProductoScreenState();
}

class _PublicarProductoScreenState extends State<PublicarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _descripcion = TextEditingController();
  final _cantidad = TextEditingController(text: '1');
  final _precio = TextEditingController();
  final _direccionExacta = TextEditingController();

  final CatalogoService _catalogoService = CatalogoService();
  List<Categoria> _categorias = [];
  List<UnidadMedida> _unidades = [];
  List<Departamento> _departamentos = [];
  List<Municipio> _municipiosDisponibles = [];

  Categoria? _categoriaSeleccionada;
  UnidadMedida? _unidadSeleccionada;
  Departamento? _departamentoSeleccionado;
  Municipio? _municipioSeleccionado;

  String _tipoOferta = 'Trueque';
  bool _cargandoCatalogos = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _precargarSiEsEdicion();
    _cargarCatalogos();
  }

  @override
  void dispose() {
    _nombre.dispose();
    _descripcion.dispose();
    _cantidad.dispose();
    _precio.dispose();
    _direccionExacta.dispose();
    super.dispose();
  }

  void _precargarSiEsEdicion() {
    final p = widget.productoExistente;
    if (p == null) return;
    _nombre.text = p.nombre;
    _descripcion.text = p.descripcion ?? '';
    _cantidad.text = p.cantidad.toString();
    _precio.text = p.precioReferencial?.toString() ?? '';
    _direccionExacta.text = '';
    _tipoOferta = p.tipoOferta;
  }

  Future<void> _cargarCatalogos() async {
    try {
      final categorias = await _catalogoService.categorias();
      final unidades = await _catalogoService.unidadesMedida();
      final departamentos = await _catalogoService.departamentos();

      if (!mounted) return;
      setState(() {
        _categorias = categorias;
        _unidades = unidades;
        _departamentos = departamentos;

        if (widget.productoExistente != null) {
          final p = widget.productoExistente!;
          _categoriaSeleccionada = categorias.where((c) => c.nombre == p.categoria).firstOrNull;
          _unidadSeleccionada = unidades.where((u) => u.nombre == p.unidadMedida).firstOrNull;

          _departamentoSeleccionado = departamentos.where((d) => d.nombre == p.departamento).firstOrNull;
          if (_departamentoSeleccionado != null) {
            _municipiosDisponibles = _departamentoSeleccionado!.municipios;
            _municipioSeleccionado = _municipiosDisponibles.where((m) => m.nombre == p.municipio).firstOrNull;
          }
        }
        _cargandoCatalogos = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _cargandoCatalogos = false);
      }
    }
  }

  void _onDepartamentoChanged(Departamento? dep) {
    setState(() {
      _departamentoSeleccionado = dep;
      _municipioSeleccionado = null;
      _municipiosDisponibles = dep?.municipios ?? [];
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (!widget.esEdicion && (_categoriaSeleccionada == null || _unidadSeleccionada == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona categoría y unidad de medida.')),
      );
      return;
    }

    if (_departamentoSeleccionado == null || _municipioSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el departamento y municipio de ubicación.')),
      );
      return;
    }

    setState(() => _guardando = true);
    final formulario = ProductoFormulario(
      categoriaID: _categoriaSeleccionada?.categoriaID,
      nombre: _nombre.text.trim(),
      descripcion: _descripcion.text.trim().isEmpty ? null : _descripcion.text.trim(),
      cantidad: double.tryParse(_cantidad.text) ?? 1,
      unidadMedidaID: _unidadSeleccionada?.unidadMedidaID,
      municipioID: _municipioSeleccionado!.municipioID,
      direccionExacta: _direccionExacta.text.trim().isEmpty
          ? null
          : _direccionExacta.text.trim(),
      tipoOferta: _tipoOferta,
      precioReferencial: _precio.text.trim().isEmpty ? null : double.tryParse(_precio.text),
    );

    try {
      final provider = context.read<ProductoProvider>();
      if (widget.esEdicion) {
        await provider.actualizar(widget.productoExistente!.productoID, formulario);
      } else {
        await provider.crear(formulario);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e is ApiException ? e.mensaje : 'No se pudo guardar el producto.')),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.esEdicion ? 'Editar producto' : 'Publicar producto')),
      body: _cargandoCatalogos
          ? const Center(child: CircularProgressIndicator(color: AppColors.verdeMilpa))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    AppTextField(
                      etiqueta: 'Nombre del producto',
                      controller: _nombre,
                      validador: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un nombre' : null,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      etiqueta: 'Descripción',
                      controller: _descripcion,
                      maxLineas: 3,
                    ),
                    const SizedBox(height: 14),
                    if (!widget.esEdicion) ...[
                      DropdownButtonFormField<Categoria>(
                        initialValue: _categoriaSeleccionada,
                        decoration: const InputDecoration(labelText: 'Categoría'),
                        items: _categorias
                            .map((c) => DropdownMenuItem(value: c, child: Text(c.nombre)))
                            .toList(),
                        onChanged: (v) => setState(() => _categoriaSeleccionada = v),
                      ),
                      const SizedBox(height: 14),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            etiqueta: 'Cantidad',
                            controller: _cantidad,
                            tipoTeclado: TextInputType.number,
                            validador: (v) => (double.tryParse(v ?? '') == null) ? 'Cantidad inválida' : null,
                          ),
                        ),
                        if (!widget.esEdicion) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<UnidadMedida>(
                              initialValue: _unidadSeleccionada,
                              decoration: const InputDecoration(labelText: 'Unidad'),
                              items: _unidades
                                  .map((u) => DropdownMenuItem(value: u, child: Text(u.nombre)))
                                  .toList(),
                              onChanged: (v) => setState(() => _unidadSeleccionada = v),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 18),
                    
                    // Sección de Ubicación Geográfica
                    Text('Ubicación del producto', style: AppTextStyles.etiqueta),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Departamento>(
                            initialValue: _departamentoSeleccionado,
                            isExpanded: true,
                            decoration: const InputDecoration(labelText: 'Departamento'),
                            items: _departamentos
                                .map((d) => DropdownMenuItem(value: d, child: Text(d.nombre)))
                                .toList(),
                            onChanged: _onDepartamentoChanged,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<Municipio>(
                            initialValue: _municipioSeleccionado,
                            isExpanded: true,
                            decoration: const InputDecoration(labelText: 'Municipio'),
                            items: _municipiosDisponibles
                                .map((m) => DropdownMenuItem(value: m, child: Text(m.nombre)))
                                .toList(),
                            onChanged: _departamentoSeleccionado == null
                                ? null
                                : (v) => setState(() => _municipioSeleccionado = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      etiqueta: 'Comarca / Dirección exacta (Opcional)',
                      controller: _direccionExacta,
                    ),

                    const SizedBox(height: 18),
                    Text('Tipo de oferta', style: AppTextStyles.etiqueta),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: ['Trueque', 'Venta', 'Ambos']
                          .map((t) => ChoiceChip(
                                label: Text(t),
                                selected: _tipoOferta == t,
                                selectedColor: AppColors.verdeMilpaSuave,
                                onSelected: (_) => setState(() => _tipoOferta = t),
                              ))
                          .toList(),
                    ),
                    if (_tipoOferta != 'Trueque') ...[
                      const SizedBox(height: 14),
                      AppTextField(
                        etiqueta: 'Precio referencial (C\$)',
                        controller: _precio,
                        tipoTeclado: TextInputType.number,
                      ),
                    ],
                    const SizedBox(height: 28),
                    AppButton(
                      texto: widget.esEdicion ? 'Guardar cambios' : 'Publicar producto',
                      onPressed: _guardar,
                      cargando: _guardando,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
