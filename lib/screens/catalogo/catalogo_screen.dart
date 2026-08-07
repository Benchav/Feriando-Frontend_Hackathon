import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/catalogos.dart';
import '../../providers/producto_provider.dart';
import '../../services/catalogo_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/producto_card.dart';
import '../notificaciones/notificaciones_screen.dart';
import 'detalle_producto_screen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final _busquedaController = TextEditingController();
  final CatalogoService _catalogoService = CatalogoService();

  List<Categoria> _categorias = [];
  List<Departamento> _departamentos = [];
  Departamento? _departamentoSeleccionado;
  
  List<Municipio> _municipiosDisponibles = [];
  Municipio? _municipioSeleccionado;

  bool _mostrarFiltrosUbicacion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductoProvider>().cargarCatalogo();
    });
    _cargarCatalogos();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _cargarCatalogos() async {
    try {
      final cats = await _catalogoService.categorias();
      final deps = await _catalogoService.departamentos();
      if (!mounted) return;
      setState(() {
        _categorias = cats;
        _departamentos = deps;
      });
    } catch (_) {}
  }

  void _onDepartamentoChanged(Departamento? dep) {
    final provider = context.read<ProductoProvider>();
    setState(() {
      _departamentoSeleccionado = dep;
      _municipioSeleccionado = null;
      _municipiosDisponibles = dep?.municipios ?? [];
    });
    
    provider.filtroDepartamentoID = dep?.departamentoID;
    provider.filtroMunicipioID = null;
    provider.cargarCatalogo();
  }

  void _onMunicipioChanged(Municipio? mun) {
    final provider = context.read<ProductoProvider>();
    setState(() {
      _municipioSeleccionado = mun;
    });

    provider.filtroMunicipioID = mun?.municipioID;
    provider.cargarCatalogo();
  }

  void _limpiarFiltrosUbicacion() {
    final provider = context.read<ProductoProvider>();
    setState(() {
      _departamentoSeleccionado = null;
      _municipioSeleccionado = null;
      _municipiosDisponibles = [];
    });
    provider.filtroDepartamentoID = null;
    provider.filtroMunicipioID = null;
    provider.cargarCatalogo();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('El Trueque'),
        actions: [
          IconButton(
            icon: Icon(
              _mostrarFiltrosUbicacion ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: (_departamentoSeleccionado != null) ? AppColors.verdeMilpa : null,
            ),
            tooltip: 'Filtrar por ubicación',
            onPressed: () {
              setState(() => _mostrarFiltrosUbicacion = !_mostrarFiltrosUbicacion);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificacionesScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.cargarCatalogo(),
        child: Column(
          children: [
            // Buscador por texto
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _busquedaController,
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _busquedaController.clear();
                      provider.filtroBusqueda = null;
                      provider.cargarCatalogo();
                    },
                  ),
                ),
                onSubmitted: (v) {
                  provider.filtroBusqueda = v;
                  provider.cargarCatalogo();
                },
              ),
            ),

            // Panel Desplegable de Filtros por Ubicación
            if (_mostrarFiltrosUbicacion)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Departamento>(
                            initialValue: _departamentoSeleccionado,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Departamento',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            items: _departamentos
                                .map((d) => DropdownMenuItem(value: d, child: Text(d.nombre)))
                                .toList(),
                            onChanged: _onDepartamentoChanged,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<Municipio>(
                            initialValue: _municipioSeleccionado,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Municipio',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            items: _municipiosDisponibles
                                .map((m) => DropdownMenuItem(value: m, child: Text(m.nombre)))
                                .toList(),
                            onChanged: _departamentoSeleccionado == null ? null : _onMunicipioChanged,
                          ),
                        ),
                      ],
                    ),
                    if (_departamentoSeleccionado != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: _limpiarFiltrosUbicacion,
                          icon: const Icon(Icons.clear, size: 16),
                          label: const Text('Limpiar ubicación'),
                        ),
                      ),
                  ],
                ),
              ),

            // Chips de Categorías
            if (_categorias.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _chipCategoria(context, null, 'Todas'),
                    ..._categorias.map((c) => _chipCategoria(context, c.categoriaID, c.nombre)),
                  ],
                ),
              ),
            const SizedBox(height: 8),

            // Lista de Productos
            Expanded(child: _cuerpo(provider)),
          ],
        ),
      ),
    );
  }

  Widget _chipCategoria(BuildContext context, int? id, String nombre) {
    final provider = context.read<ProductoProvider>();
    final seleccionado = provider.filtroCategoriaID == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(nombre),
        selected: seleccionado,
        selectedColor: AppColors.verdeMilpaSuave,
        onSelected: (_) {
          provider.filtroCategoriaID = id;
          provider.cargarCatalogo();
        },
      ),
    );
  }

  Widget _cuerpo(ProductoProvider provider) {
    if (provider.cargando && provider.catalogo.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.verdeMilpa));
    }
    if (provider.catalogo.isEmpty) {
      return const EmptyState(
        icono: Icons.search_off,
        titulo: 'No hay productos por aquí',
        mensaje: 'Prueba ajustando los filtros de búsqueda o ubicación.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: provider.catalogo.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final producto = provider.catalogo[i];
        return ProductoCard(
          producto: producto,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DetalleProductoScreen(productoID: producto.productoID)),
          ),
        );
      },
    );
  }
}
