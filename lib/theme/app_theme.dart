import 'package:flutter/material.dart';

import 'color_schemes.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      );

  static ThemeData get darkTheme => ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
      );
}
