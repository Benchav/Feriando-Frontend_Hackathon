import 'package:flutter/material.dart';
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

  final _pantallas = const [
    CatalogoScreen(),
    MisProductosScreen(),
    TruequesScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indice, children: _pantallas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (i) => setState(() => _indice = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: 'Catálogo'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Mis productos'),
          BottomNavigationBarItem(icon: Icon(Icons.sync_alt_outlined), activeIcon: Icon(Icons.sync_alt), label: 'Trueques'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
