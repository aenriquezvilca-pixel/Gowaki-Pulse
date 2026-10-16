import 'package:flutter/material.dart';

/// Datos estáticos / mock. No hay backend ni persistencia (fuera del alcance).

enum Estado { revision, aprobada, cambios }

class Ruta {
  final String fecha, desde, hasta;
  final double km;
  final Estado estado;
  final String? comentario;
  const Ruta(this.fecha, this.desde, this.hasta, this.km, this.estado,
      {this.comentario});
}

const rutasMock = <Ruta>[
  Ruta('10 oct 2026', 'San Blas', 'Plaza de Armas', 4.2, Estado.revision),
  Ruta('03 oct 2026', 'Wanchaq', 'Mercado San Pedro', 5.6, Estado.aprobada),
  Ruta('24 sep 2026', 'Ttio', 'Av. El Sol', 3.8, Estado.cambios,
      comentario:
          'El tramo entre Ttio y Av. El Sol no tiene un punto de inicio claro. '
          'Ajusta el trazado en la zona de la plaza y vuelve a enviarla.'),
  Ruta('12 sep 2026', 'Santiago', 'Plaza de Armas', 4.5, Estado.aprobada),
  Ruta('28 ago 2026', 'San Sebastián', 'Av. de la Cultura', 2.9,
      Estado.revision),
  Ruta('15 ago 2026', 'Lucrepata', 'San Blas', 3.8, Estado.aprobada),
];

String kmFmt(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

class Perfil {
  final String nombre, correo, telefono, ciudad, bio;
  const Perfil({
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.ciudad,
    required this.bio,
  });

  Perfil copyWith(
          {String? nombre,
          String? correo,
          String? telefono,
          String? ciudad,
          String? bio}) =>
      Perfil(
        nombre: nombre ?? this.nombre,
        correo: correo ?? this.correo,
        telefono: telefono ?? this.telefono,
        ciudad: ciudad ?? this.ciudad,
        bio: bio ?? this.bio,
      );

  String get iniciales {
    final p = nombre.trim().split(RegExp(r'\s+'));
    if (p.isEmpty || p.first.isEmpty) return '?';
    return (p.first[0] + (p.length > 1 ? p.last[0] : '')).toUpperCase();
  }
}

final perfil = ValueNotifier<Perfil>(const Perfil(
  nombre: 'Mateo Quispe',
  correo: 'mateo.quispe@gowayki.pe',
  telefono: '+51 984 123 456',
  ciudad: 'Cusco, Perú',
  bio: 'Camino Cusco para mapear rutas seguras y accesibles.',
));

/// Estado de la demo
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final notificaciones = ValueNotifier<bool>(true);
final simularVacio = ValueNotifier<bool>(false);
