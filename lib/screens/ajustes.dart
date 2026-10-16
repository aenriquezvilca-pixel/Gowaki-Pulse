import 'package:flutter/material.dart';

import '../data.dart';
import '../shell.dart';
import '../theme.dart';
import '../widgets.dart';

void _ir(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

// ----------------------------------------------------------------- AJUSTES
class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    final p = perfil.value;
    return ScreenFrame(title: 'Ajustes', children: [
      Row(children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: c.accentSoft, shape: BoxShape.circle),
          child: Text(p.iniciales,
              style: hStyle(c, size: 18, color: c.accentText)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.nombre, style: mStyle(c)),
            Text('Voluntario · ${p.ciudad}', style: bStyle(c, size: 12.5)),
          ]),
        ),
      ]),
      const SectionLabel('Apariencia'),
      ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (_, mode, __) => PulseCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Tema de la aplicación', style: mStyle(c, size: 15)),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: _TemaOpcion('Claro', Icons.light_mode_outlined,
                      mode == ThemeMode.light, ThemeMode.light)),
              const SizedBox(width: 10),
              Expanded(
                  child: _TemaOpcion('Oscuro', Icons.dark_mode_outlined,
                      mode == ThemeMode.dark, ThemeMode.dark)),
            ]),
          ]),
        ),
      ),
      const SectionLabel('Notificaciones'),
      ValueListenableBuilder<bool>(
        valueListenable: notificaciones,
        builder: (_, on, __) => PulseCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(on ? Icons.notifications_active_outlined : Icons.notifications_off_outlined,
                  color: c.sub),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recibir notificaciones', style: mStyle(c)),
                      Text(on ? 'Activadas' : 'Desactivadas',
                          style: bStyle(c, size: 12.5)),
                    ]),
              ),
              Switch(
                value: on,
                onChanged: (v) => notificaciones.value = v,
                activeTrackColor: c.accent,
                thumbColor: const WidgetStatePropertyAll(Colors.white),
              ),
            ]),
            const SizedBox(height: 10),
            Text('Avisos sobre la revisión de tus rutas y novedades de la comunidad.',
                style: bStyle(c, size: 12.5)),
          ]),
        ),
      ),
      const SectionLabel('Cuenta'),
      _Fila(Icons.logout, 'Cerrar sesión', 'Podrás volver cuando quieras',
          () => _ir(context, const CerrarSesionScreen())),
      const SizedBox(height: 10),
      _Fila(Icons.delete_outline, 'Eliminar cuenta', 'Esta acción es irreversible',
          () => _ir(context, const EliminarCuentaScreen()),
          peligro: true),
      const SectionLabel('Modo demo'),
      ValueListenableBuilder<bool>(
        valueListenable: simularVacio,
        builder: (_, v, __) => PulseCard(
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Simular sin rutas', style: mStyle(c)),
                Text('Muestra el estado vacío de "Rutas enviadas"',
                    style: bStyle(c, size: 12.5)),
              ]),
            ),
            Switch(
              value: v,
              onChanged: (x) => simularVacio.value = x,
              activeTrackColor: c.accent,
              thumbColor: const WidgetStatePropertyAll(Colors.white),
            ),
          ]),
        ),
      ),
    ]);
  }
}

class _TemaOpcion extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final ThemeMode mode;
  const _TemaOpcion(this.label, this.icon, this.selected, this.mode);
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? c.accentSoft : c.bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusBtn),
          side: BorderSide(color: selected ? c.accent : c.border, width: selected ? 1.5 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadiusBtn),
          onTap: () => themeMode.value = mode,
          child: SizedBox(
            height: 48,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 20, color: selected ? c.accentText : c.sub),
              const SizedBox(width: 8),
              Text(label,
                  style: bStyle(c,
                      size: 14,
                      w: FontWeight.w600,
                      color: selected ? c.accentText : c.text)),
              if (selected) ...[
                const SizedBox(width: 6),
                Icon(Icons.check, size: 18, color: c.accentText),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final VoidCallback onTap;
  final bool peligro;
  const _Fila(this.icon, this.title, this.sub, this.onTap, {this.peligro = false});
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    final col = peligro ? c.danger : c.text;
    return PulseCard(
      onTap: onTap,
      child: Row(children: [
        Icon(icon, color: peligro ? c.danger : c.sub),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: mStyle(c, color: col)),
            Text(sub, style: bStyle(c, size: 12.5)),
          ]),
        ),
        Icon(Icons.chevron_right, color: c.sub),
      ]),
    );
  }
}

// ------------------------------------------------------------ CERRAR SESIÓN
class CerrarSesionScreen extends StatelessWidget {
  const CerrarSesionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    final p = perfil.value;
    return ScreenFrame(title: 'Cerrar sesión', children: [
      const SizedBox(height: 16),
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            color: c.accentSoft, borderRadius: BorderRadius.circular(20)),
        child: Icon(Icons.logout, color: c.accentText, size: 30),
      ),
      const SizedBox(height: 20),
      Text('¿Quieres cerrar sesión?', style: hStyle(c, size: 28)),
      const SizedBox(height: 10),
      Text(
          'Tus rutas y tu progreso se mantienen guardados. Podrás volver a entrar cuando quieras.',
          style: bStyle(c)),
      const SizedBox(height: 20),
      PulseCard(
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: c.accentSoft, shape: BoxShape.circle),
            child: Text(p.iniciales, style: hStyle(c, size: 15, color: c.accentText)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.nombre, style: mStyle(c, size: 15)),
              Text(p.correo, style: bStyle(c, size: 12.5)),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 28),
      PButton('Cerrar sesión',
          icon: Icons.logout,
          onPressed: () => Navigator.of(context, rootNavigator: true)
              .pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) => const SalidaScreen(
                            icono: Icons.waving_hand_outlined,
                            titulo: 'Sesión cerrada',
                            texto:
                                'Gracias por contribuir con GoWayki Pulse. Vuelve cuando quieras.',
                          )),
                  (_) => false)),
      const SizedBox(height: 10),
      PButton('Cancelar',
          kind: PKind.secondary,
          onPressed: () => Navigator.of(context).maybePop()),
    ]);
  }
}

// ----------------------------------------------------------- ELIMINAR CUENTA
class EliminarCuentaScreen extends StatefulWidget {
  const EliminarCuentaScreen({super.key});
  @override
  State<EliminarCuentaScreen> createState() => _EliminarCuentaScreenState();
}

class _EliminarCuentaScreenState extends State<EliminarCuentaScreen> {
  bool _entiendo = false;

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    final p = perfil.value;
    return ScreenFrame(title: 'Eliminar cuenta', children: [
      const SizedBox(height: 8),
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            color: c.dangerBg, borderRadius: BorderRadius.circular(20)),
        child: Icon(Icons.warning_amber_rounded, color: c.danger, size: 32),
      ),
      const SizedBox(height: 20),
      Text('¿Eliminar tu cuenta?', style: hStyle(c, size: 28)),
      const SizedBox(height: 10),
      Text(
          '${p.nombre.split(' ').first}, eliminarás tu perfil de GoWayki Pulse y perderás el acceso a tus contribuciones.',
          style: bStyle(c)),
      const SizedBox(height: 18),
      PulseCard(
        color: c.dangerBg,
        borderColor: Colors.transparent,
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Esta acción es irreversible.', style: mStyle(c, color: c.text)),
          const SizedBox(height: 12),
          for (final t in const [
            'Se eliminarán tus datos de perfil.',
            'Perderás tu historial de 6 rutas y 8 reportes.',
            'No podrás recuperar esta cuenta.',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.close, size: 18, color: c.danger),
                const SizedBox(width: 10),
                Expanded(child: Text(t, style: bStyle(c, color: c.text))),
              ]),
            ),
        ]),
      ),
      const SizedBox(height: 12),
      InkWell(
        borderRadius: BorderRadius.circular(kRadiusBtn),
        onTap: () => setState(() => _entiendo = !_entiendo),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Checkbox(
              value: _entiendo,
              onChanged: (v) => setState(() => _entiendo = v ?? false),
              activeColor: c.accent,
            ),
            Expanded(
                child: Text('Entiendo que no se puede deshacer',
                    style: bStyle(c, color: c.text))),
          ]),
        ),
      ),
      const SizedBox(height: 12),
      PButton('Cancelar',
          kind: PKind.secondary,
          onPressed: () => Navigator.of(context).maybePop()),
      const SizedBox(height: 10),
      PButton('Eliminar mi cuenta definitivamente',
          kind: PKind.danger,
          onPressed: !_entiendo
              ? null
              : () => Navigator.of(context, rootNavigator: true)
                  .pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => const SalidaScreen(
                                icono: Icons.check_circle_outline,
                                titulo: 'Tu cuenta fue eliminada',
                                texto:
                                    'Eliminamos tus datos de perfil. Gracias por haber sido parte de GoWayki Pulse.',
                                boton: 'Volver al inicio',
                              )),
                      (_) => false)),
    ]);
  }
}

// ------------------------------------- PANTALLA DE DESTINO (login / despedida)
class SalidaScreen extends StatelessWidget {
  final IconData icono;
  final String titulo, texto, boton;
  const SalidaScreen({
    super.key,
    required this.icono,
    required this.titulo,
    required this.texto,
    this.boton = 'Iniciar sesión',
  });

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPad),
          child: Column(children: [
            const SizedBox(height: 16),
            const PulseLogo(size: 36),
            const Spacer(),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                  color: c.accentSoft, borderRadius: BorderRadius.circular(28)),
              child: Icon(icono, size: 46, color: c.accentText),
            ),
            const SizedBox(height: 24),
            Text(titulo, textAlign: TextAlign.center, style: hStyle(c, size: 28)),
            const SizedBox(height: 10),
            Text(texto, textAlign: TextAlign.center, style: bStyle(c)),
            const Spacer(),
            PButton(boton,
                icon: Icons.login,
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const Shell()),
                    (_) => false)),
            const SizedBox(height: 10),
            PButton('Crear cuenta nueva',
                kind: PKind.secondary,
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro fuera del alcance de la demo')))),
          ]),
        ),
      ),
    );
  }
}
