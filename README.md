# GoWayki Pulse · Demo Flutter (GOW-PULSE-26-012)

Demo navegable de las pantallas de perfil. **Solo UI/UX**: datos estáticos, sin Supabase ni persistencia.

## Cómo correrla
```bash
# 1) Dentro de esta carpeta, genera las plataformas (no sobreescribe lib/ ni pubspec.yaml)
flutter create --platforms=android,ios,web .
# 2) Dependencias y ejecución
flutter pub get
flutter run            # elige dispositivo / emulador (o: flutter run -d chrome)
```

## Pantallas
Perfil · Estadísticas · Rutas enviadas (filtros, estado vacío, detalle de "Requiere cambios", botón Crear ruta) ·
Editar perfil (validación) · Ajustes (tema claro/oscuro en vivo, notificaciones) · Cerrar sesión · Eliminar cuenta ·
Pantalla de destino (sesión cerrada / cuenta eliminada).

## Notas de diseño
- **Barra inferior fija** (5 ítems, "Contribuir" central) y cabecera fija; solo el contenido hace scroll vertical.
- Radios y bordes unificados en `lib/theme.dart` (`kRadius`, `kRadiusBtn`).
- Paleta (003) y tipografías (004: Ubuntu, Poppins, Righteous) vía `google_fonts` (requiere internet la primera vez).
- Íconos: Material Icons como sustituto temporal de los SVG (006). Isotipo (005): marcador de posición en `PulseLogo`.
- Interruptor "Modo demo → Simular sin rutas" en Ajustes para ver el estado vacío.

## Estructura
```
lib/
  main.dart        # app + tema claro/oscuro
  shell.dart       # barra inferior fija + navegación por pestañas
  theme.dart       # paleta, tipografía, radios
  data.dart        # datos mock
  widgets.dart     # tarjetas, botones, cabecera fija, hojas
  screens/         # perfil.dart, rutas.dart, ajustes.dart
```
