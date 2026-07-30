import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/catalogos.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_client.dart';
import '../../services/catalogo_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _telefono = TextEditingController();
  final _correo = TextEditingController();
  final _direccionExacta = TextEditingController();
  final _password = TextEditingController();

  final CatalogoService _catalogoService = CatalogoService();
  
  List<Departamento> _departamentos = [];
  Departamento? _departamentoSeleccionado;
  
  List<Municipio> _municipiosDisponibles = [];
  Municipio? _municipioSeleccionado;

  List<Idioma> _idiomas = [];
  Idioma? _idiomaSeleccionado;

  String _genero = 'F';
  bool _esProductora = true;
  bool _cargando = false;
  bool _cargandoCatalogos = true;

  @override
  void initState() {
    super.initState();
    _cargarCatalogosIniciales();
  }

  @override
  void dispose() {
    _nombres.dispose();
    _apellidos.dispose();
    _telefono.dispose();
    _correo.dispose();
    _direccionExacta.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _cargarCatalogosIniciales() async {
    try {
      final deps = await _catalogoService.departamentos();
      final ids = await _catalogoService.idiomas();
      if (!mounted) return;
      setState(() {
        _departamentos = deps;
        _idiomas = ids;
        _cargandoCatalogos = false;
      });
    } catch (_) {
      if (mounted) setState(() => _cargandoCatalogos = false);
    }
  }

  void _onDepartamentoChanged(Departamento? dep) {
    setState(() {
      _departamentoSeleccionado = dep;
      _municipioSeleccionado = null;
      _municipiosDisponibles = dep?.municipios ?? [];
    });
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_municipioSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona tu municipio.')),
      );
      return;
    }
    setState(() => _cargando = true);
    try {
      await context.read<AuthProvider>().registro(
            nombres: _nombres.text.trim(),
            apellidos: _apellidos.text.trim(),
            telefono: _telefono.text.trim(),
            correo: _correo.text.trim().isEmpty ? null : _correo.text.trim(),
            password: _password.text,
            genero: _genero,
            municipioID: _municipioSeleccionado!.municipioID,
            direccionExacta: _direccionExacta.text.trim(),
            idiomaPreferidoID: _idiomaSeleccionado?.idiomaID,
            esProductora: _esProductora,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is ApiException ? e.mensaje : 'No se pudo crear la cuenta.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AppTextField(
                etiqueta: 'Nombres',
                controller: _nombres,
                validador: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tus nombres' : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                etiqueta: 'Apellidos',
                controller: _apellidos,
                validador: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tus apellidos' : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                etiqueta: 'Número de teléfono',
                controller: _telefono,
                tipoTeclado: TextInputType.phone,
                validador: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tu teléfono' : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                etiqueta: 'Correo (opcional)',
                controller: _correo,
                tipoTeclado: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              AppTextField(
                etiqueta: 'Contraseña',
                controller: _password,
                esPassword: true,
                validador: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 14),
              
              if (_cargandoCatalogos)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(color: AppColors.verdeMilpa),
                )
              else ...[
                // Dropdown 1: Departamento
                DropdownButtonFormField<Departamento>(
                  value: _departamentoSeleccionado,
                  decoration: const InputDecoration(labelText: 'Departamento'),
                  items: _departamentos
                      .map((d) => DropdownMenuItem(value: d, child: Text(d.nombre)))
                      .toList(),
                  onChanged: _onDepartamentoChanged,
                  validator: (v) => v == null ? 'Selecciona tu departamento' : null,
                ),
                const SizedBox(height: 14),

                // Dropdown 2: Municipio (en cascada)
                DropdownButtonFormField<Municipio>(
                  value: _municipioSeleccionado,
                  decoration: const InputDecoration(labelText: 'Municipio'),
                  items: _municipiosDisponibles
                      .map((m) => DropdownMenuItem(value: m, child: Text(m.nombre)))
                      .toList(),
                  onChanged: _departamentoSeleccionado == null
                      ? null
                      : (v) => setState(() => _municipioSeleccionado = v),
                  validator: (v) => v == null ? 'Selecciona tu municipio' : null,
                ),
                const SizedBox(height: 14),

                // Dirección Exacta
                AppTextField(
                  etiqueta: 'Dirección exacta / Comarca',
                  controller: _direccionExacta,
                  validador: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tu dirección' : null,
                ),
                const SizedBox(height: 14),

                // Dropdown 3: Idioma (Opcional)
                DropdownButtonFormField<Idioma>(
                  value: _idiomaSeleccionado,
                  decoration: const InputDecoration(labelText: 'Idioma preferido (opcional)'),
                  items: _idiomas
                      .map((i) => DropdownMenuItem(value: i, child: Text(i.nombre)))
                      .toList(),
                  onChanged: (v) => setState(() => _idiomaSeleccionado = v),
                ),
              ],

              const SizedBox(height: 14),
              Text('Género', style: AppTextStyles.etiqueta),
              Row(
                children: [
                  ChoiceChip(label: const Text('Femenino'), selected: _genero == 'F', onSelected: (_) => setState(() => _genero = 'F')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Masculino'), selected: _genero == 'M', onSelected: (_) => setState(() => _genero = 'M')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Otro'), selected: _genero == 'O', onSelected: (_) => setState(() => _genero = 'O')),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _esProductora,
                onChanged: (v) => setState(() => _esProductora = v),
                activeColor: AppColors.verdeMilpa,
                title: const Text('Voy a publicar productos para trueque'),
                subtitle: const Text('Puedes cambiarlo luego desde tu perfil'),
              ),
              const SizedBox(height: 24),
              AppButton(texto: 'Crear cuenta', onPressed: _registrar, cargando: _cargando),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
