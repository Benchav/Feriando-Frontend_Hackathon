import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../catalogo/catalogo_screen.dart';
import '../productos/mis_productos_screen.dart';
import '../trueques/trueques_screen.dart';
import '../perfil/perfil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indice = 0;

  final _pantallas = [
    const CatalogoScreen(),
    const MisProductosScreen(),
    const TruequesScreen(),
    const PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      body: IndexedStack(index: _indice, children: _pantallas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (i) => setState(() => _indice = i),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.storefront_outlined), activeIcon: const Icon(Icons.storefront), label: lang.translate('home_catalog')),
          BottomNavigationBarItem(icon: const Icon(Icons.inventory_2_outlined), activeIcon: const Icon(Icons.inventory_2), label: lang.translate('home_my_products')),
          BottomNavigationBarItem(icon: const Icon(Icons.sync_alt_outlined), activeIcon: const Icon(Icons.sync_alt), label: lang.translate('home_trades')),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person), label: lang.translate('home_profile')),
        ],
      ),
    );
  }
}
