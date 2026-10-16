import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data.dart';
import 'theme.dart';

class PulseLogo extends StatelessWidget {
  final double size;
  const PulseLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Image.asset(
        'assets/images/gowayki_mark.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
      const SizedBox(width: 8),
      Text('GoWayki Pulse',
          style: GoogleFonts.righteous(fontSize: size * .48, color: c.text)),
    ]);
  }
}

class PulseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  const PulseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Material(
      color: color ?? c.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius),
        side: BorderSide(color: borderColor ?? c.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final Estado estado;
  const StatusBadge(this.estado, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    late final Color fg, bg;
    late final IconData icon;
    late final String text;
    switch (estado) {
      case Estado.revision:
        fg = c.warn;
        bg = c.warnBg;
        icon = Icons.schedule;
        text = 'En revisión';
      case Estado.aprobada:
        fg = c.success;
        bg = c.successBg;
        icon = Icons.check_circle_outline;
        text = 'Aprobada';
      case Estado.cambios:
        fg = c.danger;
        bg = c.dangerBg;
        icon = Icons.error_outline;
        text = 'Requiere cambios';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: fg),
        const SizedBox(width: 6),
        Text(text, style: bStyle(c, size: 12, w: FontWeight.w500, color: fg)),
      ]),
    );
  }
}

enum PKind { primary, secondary, danger }

class PButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PKind kind;
  const PButton(this.label,
      {super.key, this.onPressed, this.icon, this.kind = PKind.primary});

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusBtn));
    final txt = GoogleFonts.ubuntu(
        fontSize: 15 * kTextScale, fontWeight: FontWeight.w700);
    final child = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
      Flexible(child: Text(label, textAlign: TextAlign.center)),
    ]);
    if (kind == PKind.secondary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: c.text,
          side: BorderSide(color: c.border),
          shape: shape,
          textStyle: txt,
        ),
        child: child,
      );
    }
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        backgroundColor: kind == PKind.danger ? c.dangerBtn : c.accent,
        foregroundColor: Colors.white,
        disabledBackgroundColor: c.border,
        disabledForegroundColor: c.sub,
        shape: shape,
        textStyle: txt,
      ),
      child: child,
    );
  }
}

/// Estructura de pantalla: cabecera FIJA arriba (el estado del sistema lo
/// dibuja el SO) y solo el contenido [children] se desplaza con scroll vertical.
class ScreenFrame extends StatelessWidget {
  final String? title;
  final bool showBack;
  final Widget? trailing;
  final List<Widget> children;
  const ScreenFrame({
    super.key,
    this.title,
    this.showBack = true,
    this.trailing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          // ---- Cabecera fija ----
          Padding(
            padding: const EdgeInsets.fromLTRB(kPad, 8, kPad, 0),
            child: Row(children: [
              const PulseLogo(),
              const Spacer(),
              if (title == null && trailing != null) trailing!,
            ]),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(kPad, 16, kPad, 8),
              child: Row(children: [
                if (showBack) ...[
                  _BackButton(),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(title!,
                      style: hStyle(c, size: 28),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                if (trailing != null) trailing!,
              ]),
            ),
          // ---- Contenido que se desplaza ----
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(kPad, 12, kPad, 24),
              children: children,
            ),
          ),
        ]),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Semantics(
      button: true,
      label: 'Volver',
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusBtn),
          side: BorderSide(color: c.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadiusBtn),
          onTap: () => Navigator.of(context).maybePop(),
          child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.arrow_back, color: c.text, size: 22)),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    final c = PC.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(text, style: mStyle(c, size: 16)),
    );
  }
}

/// Hoja "Crear ruta" (mock, sin lógica real).
void mostrarCrearRuta(BuildContext context) {
  final c = PC.of(context);
  final messenger = ScaffoldMessenger.of(context);
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: c.surface,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(
          kPad, 12, kPad, MediaQuery.of(ctx).viewInsets.bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: c.border, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Crear ruta', style: hStyle(c, size: 24))),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
              'Aquí se abrirá el mapa para trazar tu recorrido. En esta demo '
              'solo simulamos el envío.',
              style: bStyle(c)),
        ),
        const SizedBox(height: 16),
        _sheetField(c, 'Punto de inicio', Icons.trip_origin),
        const SizedBox(height: 12),
        _sheetField(c, 'Punto de llegada', Icons.place_outlined),
        const SizedBox(height: 20),
        PButton('Enviar a revisión', icon: Icons.send_outlined, onPressed: () {
          Navigator.of(ctx).pop();
          messenger.showSnackBar(
              const SnackBar(content: Text('Ruta enviada a revisión (demo)')));
        }),
      ]),
    ),
  );
}

Widget _sheetField(PC c, String hint, IconData icon) => TextField(
      style: bStyle(c, color: c.text),
      decoration: inputDeco(c, hint: hint, icon: icon),
    );

InputDecoration inputDeco(PC c, {String? hint, IconData? icon}) {
  OutlineInputBorder b(Color col, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(kRadiusBtn),
      borderSide: BorderSide(color: col, width: w));
  return InputDecoration(
    hintText: hint,
    hintStyle: bStyle(c),
    prefixIcon: icon == null ? null : Icon(icon, color: c.sub, size: 20),
    filled: true,
    fillColor: c.bg,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: b(c.border),
    border: b(c.border),
    focusedBorder: b(c.accent, 1.5),
    errorBorder: b(c.danger),
    focusedErrorBorder: b(c.danger, 1.5),
    errorStyle: bStyle(c, size: 12, color: c.danger),
  );
}
