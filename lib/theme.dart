import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Radios unificados: todas las tarjetas, botones y campos comparten medidas.
const double kRadius = 16; // tarjetas
const double kRadiusBtn = 14; // botones y campos
const double kPad = 20; // margen lateral de pantalla
const double kTextScale = 0.9;

/// Paleta (003) en modo claro y oscuro.
class PC {
  final Color bg, surface, border, text, sub, accent, accentText, accentSoft;
  final Color success, successBg, warn, warnBg, danger, dangerBg, dangerBtn;

  const PC({
    required this.bg,
    required this.surface,
    required this.border,
    required this.text,
    required this.sub,
    required this.accent,
    required this.accentText,
    required this.accentSoft,
    required this.success,
    required this.successBg,
    required this.warn,
    required this.warnBg,
    required this.danger,
    required this.dangerBg,
    required this.dangerBtn,
  });

  static const light = PC(
    bg: Color(0xFFFDFBF7),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFE6DED3),
    text: Color(0xFF2B2420),
    sub: Color(0xFF6B625A),
    accent: Color(0xFFE5500A),
    accentText: Color(0xFFC2410C),
    accentSoft: Color(0xFFFDEBDD),
    success: Color(0xFF1F6B3A),
    successBg: Color(0xFFE7F3EA),
    warn: Color(0xFF8A5A00),
    warnBg: Color(0xFFFFF1D0),
    danger: Color(0xFFA3202F),
    dangerBg: Color(0xFFFBECEF),
    dangerBtn: Color(0xFF3A1A20),
  );

  static const dark = PC(
    bg: Color(0xFF141110),
    surface: Color(0xFF1E1A18),
    border: Color(0xFF3A322D),
    text: Color(0xFFF5EDE4),
    sub: Color(0xFFB3A79C),
    accent: Color(0xFFF05709),
    accentText: Color(0xFFFF8A4C),
    accentSoft: Color(0xFF3A1D0E),
    success: Color(0xFF7BD39A),
    successBg: Color(0xFF1E3326),
    warn: Color(0xFFF0C060),
    warnBg: Color(0xFF3A2E12),
    danger: Color(0xFFF29AA6),
    dangerBg: Color(0xFF3A1A20),
    dangerBtn: Color(0xFFB3263A),
  );

  static PC of(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? dark : light;
}

/// Tipografía (004): Ubuntu para títulos, Poppins para cuerpo, Righteous para marca.
TextStyle hStyle(PC c, {double size = 28, Color? color}) => GoogleFonts.ubuntu(
      fontSize: size * kTextScale,
      fontWeight: FontWeight.w700,
      color: color ?? c.text,
      height: 1.15,
    );

TextStyle mStyle(PC c, {double size = 16, Color? color}) => GoogleFonts.ubuntu(
      fontSize: size * kTextScale,
      fontWeight: FontWeight.w500,
      color: color ?? c.text,
      height: 1.25,
    );

TextStyle bStyle(PC c,
        {double size = 14,
        FontWeight w = FontWeight.w400,
        Color? color,
        double h = 1.45}) =>
    GoogleFonts.poppins(
      fontSize: size * kTextScale,
      fontWeight: w,
      color: color ?? c.sub,
      height: h,
    );

ThemeData buildTheme(Brightness b) {
  final c = b == Brightness.dark ? PC.dark : PC.light;
  final base = ThemeData(brightness: b, useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: c.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: c.accent, brightness: b)
        .copyWith(surface: c.surface, primary: c.accent),
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme)
        .apply(bodyColor: c.text, displayColor: c.text),
    splashFactory: InkRipple.splashFactory,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.text,
      contentTextStyle:
          GoogleFonts.poppins(color: c.bg, fontSize: 13 * kTextScale),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusBtn)),
    ),
  );
}
