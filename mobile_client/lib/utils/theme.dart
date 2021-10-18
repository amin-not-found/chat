import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

MaterialColor createColorSwatch(Color color, int mainColorStrength) {
  List strengths = <int>[50];
  final swatch = <int, Color>{};
  final double r = color.red / mainColorStrength,
      g = color.green / mainColorStrength,
      b = color.blue / mainColorStrength;

  for (int i = 1; i < 10; i++) {
    strengths.add(100 * i);
  }

  strengths.forEach((strength) {
    final ds = 1000 - strength;
    swatch[strength] = Color.fromRGBO(
      (r * ds).round(),
      (g * ds).round(),
      (b * ds).round(),
      1.0,
    );
  });
  return MaterialColor(color.value, swatch);
}

class AppTheme {
  late MaterialColor primarySwatch;
  late MaterialColor secondarySwatch;
  late MaterialColor backgroundSwatch;
  late MaterialColor foregroundSwatch;
  late Brightness brightness;

  // TODO : update theme with system
  // can use WidgetsBindingObserver and didChangePlatformBrightness to achive this
  static Future<AppTheme> getTheme() async {
    var platformBrightness = WidgetsBinding.instance?.window.platformBrightness;
    var storage = GetIt.I<FlutterSecureStorage>();
    var preferredBrightness = await storage.read(key: "theme");
    AppTheme theme;
    switch (preferredBrightness) {
      case "light":
        theme = AppTheme.light();
        break;
      case "dark":
        theme = AppTheme.dark();
        break;
      default:
        theme = platformBrightness == Brightness.dark
            ? AppTheme.dark()
            : AppTheme.light();
    }
    return theme;
  }

  AppTheme.light()
      : primarySwatch = createColorSwatch(Color(0xFF00A693), 700),
        secondarySwatch = createColorSwatch(Color(0xFF00A693), 700),
        backgroundSwatch = createColorSwatch(Color(0xFFEFEEEE), 100),
        brightness = Brightness.light;

  AppTheme.dark()
      : primarySwatch = createColorSwatch(Color(0xFF00A693), 700),
        secondarySwatch = createColorSwatch(Color(0xFF00A693), 700),
        backgroundSwatch = createColorSwatch(Color(0xFF111418), 800),
        brightness = Brightness.dark;

  ThemeData getData() {
    return ThemeData(
        primarySwatch: primarySwatch,
        scaffoldBackgroundColor: backgroundSwatch,
        bottomAppBarColor: backgroundSwatch,
        brightness: brightness);
  }
}
