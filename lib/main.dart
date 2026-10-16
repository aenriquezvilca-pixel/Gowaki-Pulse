import 'package:flutter/material.dart';

import 'data.dart';
import 'shell.dart';
import 'theme.dart';

void main() => runApp(const PulseApp());

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (_, mode, __) => MaterialApp(
        title: 'GoWayki Pulse',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: mode,
        home: const Shell(),
        // En pantallas anchas (laptop) muestra la app con tamaño de celular.
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          if (mq.size.width <= 600) return child!;
          final h = mq.size.height < 892 ? mq.size.height : 892.0;
          return ColoredBox(
            color: const Color(0xFF2A2522),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: MediaQuery(
                  data: mq.copyWith(size: Size(412, h)),
                  child: SizedBox(width: 412, height: h, child: child),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}