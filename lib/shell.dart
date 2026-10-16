import 'package:flutter/material.dart';

import 'screens/perfil.dart';
import 'screens/rutas.dart';
import 'theme.dart';
import 'widgets.dart';

/// Contenedor con Bottom Navigation FIJA. Solo cambia el contenido de arriba.
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 4; // arranca en Mi perfil
  final _profileNav = GlobalKey<NavigatorState>();

  void _onTap(int i) {
    if (i == 2) {
      mostrarCrearRuta(context); // "Contribuir" abre la hoja de crear ruta
      return;
    }
    if (i == _index && i == 4) {
      _profileNav.currentState?.popUntil((r) => r.isFirst);
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final nav = _profileNav.currentState;
        if (_index == 4 && nav != null && nav.canPop()) {
          nav.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(index: _index, children: [
          const _Pronto(titulo: 'Explorar', icono: Icons.map_outlined),
          const RutasEnviadasScreen(showBack: false),
          const SizedBox.shrink(),
          const _Pronto(titulo: 'Comunidad', icono: Icons.groups_outlined),
          Navigator(
            key: _profileNav,
            onGenerateRoute: (_) =>
                MaterialPageRoute(builder: (_) => const PerfilScreen()),
          ),
        ]),
        bottomNavigationBar: PulseBottomNav(index: _index, onTap: _onTap),
      ),
    );
  }
}

class _Pronto extends StatelessWidget {
  final String titulo;
  final IconData icono;
  const _Pronto({required this.titulo, required this.icono});
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return ScreenFrame(title: titulo, showBack: false, children: [
      const SizedBox(height: 40),
      Center(
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
              color: c.accentSoft, borderRadius: BorderRadius.circular(24)),
          child: Icon(icono, size: 40, color: c.accentText),
        ),
      ),
      const SizedBox(height: 20),
      Center(child: Text('Próximamente', style: hStyle(c, size: 22))),
      const SizedBox(height: 8),
      Center(
        child: Text('Esta sección no forma parte de la demo de perfil.',
            textAlign: TextAlign.center, style: bStyle(c)),
      ),
    ]);
  }
}

class PulseBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const PulseBottomNav({super.key, required this.index, required this.onTap});

  static const _items = <(IconData, IconData, String)>[
    (Icons.map_outlined, Icons.map, 'Explorar'),
    (Icons.route_outlined, Icons.route, 'Rutas'),
    (Icons.add, Icons.add, 'Contribuir'),
    (Icons.groups_outlined, Icons.groups, 'Comunidad'),
    (Icons.person_outline, Icons.person, 'Mi perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: c.border)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(dark ? .35 : .07),
              blurRadius: 18,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: i == 2
                      ? _Center(c: c, label: _items[i].$3, onTap: () => onTap(i))
                      : _Item(
                          c: c,
                          icon: index == i ? _items[i].$2 : _items[i].$1,
                          label: _items[i].$3,
                          active: index == i,
                          onTap: () => onTap(i),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final PC c;
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Item(
      {required this.c,
      required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? c.accentText : c.sub;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 30,
              decoration: BoxDecoration(
                color: active ? c.accentSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 2),
            Text(label,
                maxLines: 1,
                style: bStyle(c,
                    size: 11,
                    w: active ? FontWeight.w600 : FontWeight.w500,
                    color: color,
                    h: 1.2)),
          ]),
        ),
      ),
    );
  }
}

class _Center extends StatelessWidget {
  final PC c;
  final String label;
  final VoidCallback onTap;
  const _Center({required this.c, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Contribuir: crear ruta',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.accent,
                boxShadow: [
                  BoxShadow(
                      color: c.accent.withOpacity(.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 2),
            Text(label,
                maxLines: 1,
                style: bStyle(c,
                    size: 11, w: FontWeight.w600, color: c.accentText, h: 1.2)),
          ]),
        ),
      ),
    );
  }
}
