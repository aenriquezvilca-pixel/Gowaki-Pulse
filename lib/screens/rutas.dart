import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class RutasEnviadasScreen extends StatefulWidget {
  final bool showBack;
  const RutasEnviadasScreen({super.key, this.showBack = true});
  @override
  State<RutasEnviadasScreen> createState() => _RutasEnviadasScreenState();
}

class _RutasEnviadasScreenState extends State<RutasEnviadasScreen> {
  int _filtro = 0;
  static const _filtros = ['Todo', 'En revisión', 'Aprobado', 'Requiere cambios'];
  static const _map = <int, Estado?>{
    0: null,
    1: Estado.revision,
    2: Estado.aprobada,
    3: Estado.cambios,
  };

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return ValueListenableBuilder<bool>(
      valueListenable: simularVacio,
      builder: (_, vacio, __) {
        final e = _map[_filtro];
        final lista = vacio
            ? <Ruta>[]
            : rutasMock.where((r) => e == null || r.estado == e).toList();
        final km = lista.fold<double>(0, (s, r) => s + r.km);

        return ScreenFrame(
          title: 'Rutas enviadas',
          showBack: widget.showBack,
          trailing: _CrearRutaPill(onTap: () => mostrarCrearRuta(context)),
          children: [
            Row(children: [
              Expanded(
                child: Text(
                    '${lista.length} ${lista.length == 1 ? 'ruta' : 'rutas'} · ${kmFmt(km)} km',
                    style: mStyle(c, size: 15)),
              ),
              Text('Más recientes', style: bStyle(c, size: 12)),
            ]),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (var i = 0; i < _filtros.length; i++) ...[
                  _Chip(
                    label: _filtros[i],
                    selected: i == _filtro,
                    onTap: () => setState(() => _filtro = i),
                  ),
                  const SizedBox(width: 8),
                ],
              ]),
            ),
            const SizedBox(height: 16),
            if (lista.isEmpty)
              _Vacio(sinRutas: vacio)
            else
              for (final r in lista) ...[
                _RutaCard(ruta: r),
                const SizedBox(height: 10),
              ],
          ],
        );
      },
    );
  }
}

class _CrearRutaPill extends StatelessWidget {
  final VoidCallback onTap;
  const _CrearRutaPill({required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Material(
      color: c.accent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.add, size: 18, color: Colors.white),
            const SizedBox(width: 4),
            Text('Crear ruta',
                style: mStyle(c, size: 13, color: Colors.white)
                    .copyWith(fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip(
      {required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? c.accent : c.surface,
        shape: StadiumBorder(
            side: BorderSide(color: selected ? c.accent : c.border)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(label,
                    style: bStyle(c,
                        size: 13,
                        w: FontWeight.w600,
                        color: selected ? Colors.white : c.text)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RutaCard extends StatelessWidget {
  final Ruta ruta;
  const _RutaCard({required this.ruta});

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    final cambios = ruta.estado == Estado.cambios;
    return PulseCard(
      onTap: cambios ? () => _detalle(context) : null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(ruta.fecha, style: bStyle(c, size: 12))),
          Text('${kmFmt(ruta.km)} km',
              style: bStyle(c, size: 12, w: FontWeight.w600, color: c.text)),
        ]),
        const SizedBox(height: 8),
        Text('${ruta.desde} → ${ruta.hasta}', style: mStyle(c, size: 16)),
        const SizedBox(height: 10),
        Row(children: [
          StatusBadge(ruta.estado),
          if (cambios) ...[
            const Spacer(),
            Text('Ver qué corregir',
                style: bStyle(c,
                    size: 12, w: FontWeight.w600, color: c.accentText)),
            Icon(Icons.chevron_right, size: 18, color: c.accentText),
          ],
        ]),
      ]),
    );
  }

  void _detalle(BuildContext context) {
    final c = PC.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(kPad, 12, kPad, 28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: c.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(ruta.estado)),
          const SizedBox(height: 12),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('${ruta.desde} → ${ruta.hasta}',
                  style: hStyle(c, size: 22))),
          const SizedBox(height: 12),
          PulseCard(
            color: c.dangerBg,
            borderColor: Colors.transparent,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Comentario del revisor',
                      style: mStyle(c, size: 14, color: c.danger)),
                  const SizedBox(height: 6),
                  Text(ruta.comentario ?? 'Sin comentarios.',
                      style: bStyle(c, color: c.text)),
                ]),
          ),
          const SizedBox(height: 16),
          PButton('Corregir y reenviar', icon: Icons.edit_outlined,
              onPressed: () => Navigator.of(ctx).pop()),
        ]),
      ),
    );
  }
}

class _Vacio extends StatelessWidget {
  final bool sinRutas;
  const _Vacio({required this.sinRutas});
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Column(children: [
      const SizedBox(height: 24),
      Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
            color: c.accentSoft, borderRadius: BorderRadius.circular(24)),
        child: Icon(Icons.route, size: 40, color: c.accentText),
      ),
      const SizedBox(height: 20),
      Text(sinRutas ? 'Aún no has enviado rutas' : 'Sin rutas en este estado',
          textAlign: TextAlign.center, style: hStyle(c, size: 22)),
      const SizedBox(height: 8),
      Text(
          sinRutas
              ? 'Tu próxima caminata puede ayudar a más personas. Registra una ruta y compártela con la comunidad.'
              : 'Cuando tengas rutas con este estado, aparecerán aquí.',
          textAlign: TextAlign.center,
          style: bStyle(c)),
      if (sinRutas) ...[
        const SizedBox(height: 24),
        PButton('Contribuir mi primera ruta',
            icon: Icons.add_circle_outline,
            onPressed: () => mostrarCrearRuta(context)),
        const SizedBox(height: 16),
        PulseCard(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.info_outline, color: c.accentText, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cada ruta cuenta', style: mStyle(c)),
                    const SizedBox(height: 4),
                    Text(
                        'Al enviarla, verás aquí su recorrido y estado de revisión.',
                        style: bStyle(c, size: 13)),
                  ]),
            ),
          ]),
        ),
      ],
    ]);
  }
}
