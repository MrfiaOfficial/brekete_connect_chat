import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  brightness: Brightness.dark,
  canvasColor: Color(0xff2b343b),
  accentColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  backgroundColor: const Color(0xFF000000),
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: const Color(0xFF4bd8a4),
);
final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  brightness: Brightness.light,
  canvasColor: Color(0xff2b343b).withOpacity(0.2),
  backgroundColor: const Color(0xFFffffff),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: const Color(0xFF4bd8a4),
);
