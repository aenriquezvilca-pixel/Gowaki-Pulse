import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'ajustes.dart';
import 'rutas.dart';

void _ir(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

// ---------------------------------------------------------------- PERFIL
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return ValueListenableBuilder<Perfil>(
      valueListenable: perfil,
      builder: (_, p, __) => ScreenFrame(
        showBack: false,
        trailing: IconButton(
          tooltip: 'Ajustes',
          icon: Icon(Icons.settings_outlined, color: c.text),
          onPressed: () => _ir(context, const AjustesScreen()),
        ),
        children: [
          const SizedBox(height: 8),
          Center(child: _Avatar(p.iniciales, size: 96)),
          const SizedBox(height: 14),
          Center(child: Text(p.nombre, style: hStyle(c, size: 23))),
          const SizedBox(height: 8),
          const Center(child: StatusPill('Voluntario')),
          const SizedBox(height: 10),
          Center(
            child: Text('${p.ciudad} · Desde agosto de 2026',
                style: bStyle(c, size: 11.5)),
          ),
          const SizedBox(height: 22),
          PulseCard(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                        child: Text('Próxima meta: 10 rutas',
                            style: mStyle(c, size: 14))),
                    Text('6 / 10',
                        style: hStyle(c, size: 16, color: c.accentText)),
                  ]),
                  const SizedBox(height: 4),
                  Text('Te faltan 4 rutas para lograrla',
                      style: bStyle(c, size: 11.5)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: .6,
                      minHeight: 8,
                      backgroundColor: c.border,
                      color: c.accent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Cada ruta cuenta.',
                      style: bStyle(c, size: 10.5)
                          .copyWith(fontStyle: FontStyle.italic)),
                ]),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Expanded(child: _Stat('6', 'RUTAS')),
            const SizedBox(width: 10),
            const Expanded(child: _Stat('24,8', 'KM RECORRIDOS')),
            const SizedBox(width: 10),
            const Expanded(child: _Stat('8', 'REPORTES')),
          ]),
          const SizedBox(height: 20),
          _Menu(Icons.bar_chart_rounded, 'Estadísticas',
              'Tu impacto en la comunidad',
              () => _ir(context, const EstadisticasScreen())),
          _Menu(Icons.route, 'Rutas enviadas', '6 rutas · Consulta sus estados',
              () => _ir(context, const RutasEnviadasScreen())),
          _Menu(Icons.edit_outlined, 'Editar perfil',
              'Nombre, foto y datos de contacto',
              () => _ir(context, const EditarPerfilScreen())),
          _Menu(Icons.tune, 'Ajustes', 'Tema y notificaciones',
              () => _ir(context, const AjustesScreen())),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String text;
  const StatusPill(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
          color: c.accentSoft, borderRadius: BorderRadius.circular(999)),
      child: Text(text,
          style: bStyle(c, size: 12, w: FontWeight.w600, color: c.accentText)),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String iniciales;
  final double size;
  const _Avatar(this.iniciales, {required this.size});
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.accentSoft,
        border: Border.all(color: c.accent.withOpacity(.4), width: 2),
      ),
      child: Text(iniciales,
          style: hStyle(c, size: size * .36, color: c.accentText)),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat(this.value, this.label);
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return PulseCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      child: Column(children: [
        Text(value, style: hStyle(c, size: 20, color: c.accentText)),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: bStyle(c, size: 9.5, w: FontWeight.w600, h: 1.25)),
      ]),
    );
  }
}

class _Menu extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final VoidCallback onTap;
  const _Menu(this.icon, this.title, this.sub, this.onTap);
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PulseCard(
        onTap: onTap,
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: c.accentSoft,
                borderRadius: BorderRadius.circular(kRadiusBtn)),
            child: Icon(icon, color: c.accentText, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: mStyle(c, size: 14)),
                  const SizedBox(height: 2),
                  Text(sub, style: bStyle(c, size: 11)),
                ]),
          ),
          Icon(Icons.chevron_right, color: c.sub),
        ]),
      ),
    );
  }
}

// ----------------------------------------------------------- ESTADÍSTICAS
class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    const meses = [('Ago', 6.7), ('Sep', 8.3), ('Oct', 9.8)];
    const maxKm = 9.8;
    const tipos = [
      ('Peatonal', 3, Icons.directions_walk),
      ('Ciclovía', 2, Icons.directions_bike),
      ('Transporte', 1, Icons.directions_bus_outlined),
    ];

    return ScreenFrame(title: 'Estadísticas', children: [
      // Tarjeta destacada
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kRadius),
          gradient: const LinearGradient(
              colors: [Color(0xFFF26B1D), Color(0xFFD14A06)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Puntos de impacto',
                      style: bStyle(c,
                          size: 13,
                          w: FontWeight.w500,
                          color: Colors.white.withOpacity(.9))),
                  const SizedBox(height: 4),
                  Text('47', style: hStyle(c, size: 48, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('+12 respecto al mes anterior',
                      style: bStyle(c,
                          size: 12, color: Colors.white.withOpacity(.9))),
                ]),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.2),
                borderRadius: BorderRadius.circular(kRadiusBtn)),
            child: const Icon(Icons.trending_up, color: Colors.white, size: 30),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      Row(children: const [
        Expanded(child: _Stat('6', 'RUTAS\nMAPEADAS')),
        SizedBox(width: 10),
        Expanded(child: _Stat('24,8', 'KM\nRECORRIDOS')),
        SizedBox(width: 10),
        Expanded(child: _Stat('8', 'REPORTES')),
      ]),
      const SectionLabel('Kilómetros por mes'),
      PulseCard(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
        child: SizedBox(
          height: 170,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final m in meses)
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(kmFmt(m.$2),
                            style: bStyle(c,
                                size: 12, w: FontWeight.w600, color: c.text)),
                        const SizedBox(height: 6),
                        Container(
                          width: 44,
                          height: 100 * m.$2 / maxKm,
                          decoration: BoxDecoration(
                            color: m.$1 == 'Oct'
                                ? c.accent
                                : c.accent.withOpacity(.35),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(m.$1, style: bStyle(c, size: 12)),
                      ]),
                ),
            ],
          ),
        ),
      ),
      const SectionLabel('Por tipo de ruta'),
      PulseCard(
        child: Column(children: [
          for (var i = 0; i < tipos.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            Row(children: [
              Icon(tipos[i].$3, color: c.accentText, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(children: [
                  Row(children: [
                    Expanded(child: Text(tipos[i].$1, style: mStyle(c, size: 14))),
                    Text('${tipos[i].$2} de 6',
                        style: bStyle(c, size: 12, w: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: tipos[i].$2 / 6,
                      minHeight: 6,
                      backgroundColor: c.border,
                      color: c.accent,
                    ),
                  ),
                ]),
              ),
            ]),
          ],
        ]),
      ),
    ]);
  }
}

// ----------------------------------------------------------- EDITAR PERFIL
class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});
  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nombre, _correo, _tel, _ciudad, _bio;

  @override
  void initState() {
    super.initState();
    final p = perfil.value;
    _nombre = TextEditingController(text: p.nombre);
    _correo = TextEditingController(text: p.correo);
    _tel = TextEditingController(text: p.telefono);
    _ciudad = TextEditingController(text: p.ciudad);
    _bio = TextEditingController(text: p.bio);
  }

  @override
  void dispose() {
    for (final t in [_nombre, _correo, _tel, _ciudad, _bio]) {
      t.dispose();
    }
    super.dispose();
  }

  void _guardar() {
    if (!_form.currentState!.validate()) return;
    perfil.value = perfil.value.copyWith(
      nombre: _nombre.text.trim(),
      correo: _correo.text.trim(),
      telefono: _tel.text.trim(),
      ciudad: _ciudad.text.trim(),
      bio: _bio.text.trim(),
    );
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cambios guardados')));
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return ScreenFrame(title: 'Editar perfil', children: [
      Center(
        child: Stack(children: [
          _Avatar(perfil.value.iniciales, size: 88),
          Positioned(
            right: 0,
            bottom: 0,
            child: Material(
              color: c.accent,
              shape: CircleBorder(side: BorderSide(color: c.bg, width: 3)),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cambiar foto (demo)'))),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.photo_camera_outlined,
                      size: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 20),
      Form(
        key: _form,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _campo(c, 'Nombre completo', _nombre,
              validator: (v) => (v == null || v.trim().length < 3)
                  ? 'Escribe tu nombre completo'
                  : null),
          _campo(c, 'Correo electrónico', _correo,
              type: TextInputType.emailAddress,
              validator: (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch((v ?? '').trim())
                  ? null
                  : 'Ingresa un correo válido'),
          _campo(c, 'Teléfono', _tel,
              type: TextInputType.phone,
              validator: (v) => (v ?? '').replaceAll(RegExp(r'\D'), '').length >= 9
                  ? null
                  : 'Ingresa un teléfono válido'),
          _campo(c, 'Ciudad', _ciudad),
          _campo(c, 'Sobre ti', _bio, lines: 3),
        ]),
      ),
      const SizedBox(height: 8),
      PButton('Guardar cambios', icon: Icons.check, onPressed: _guardar),
      const SizedBox(height: 10),
      PButton('Cancelar',
          kind: PKind.secondary,
          onPressed: () => Navigator.of(context).maybePop()),
    ]);
  }

  Widget _campo(PC c, String label, TextEditingController ctrl,
      {String? Function(String?)? validator,
      TextInputType? type,
      int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: bStyle(c, size: 13, w: FontWeight.w600, color: c.text)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          validator: validator,
          keyboardType: type,
          maxLines: lines,
          style: bStyle(c, color: c.text),
          decoration: inputDeco(c),
        ),
      ]),
    );
  }
}
