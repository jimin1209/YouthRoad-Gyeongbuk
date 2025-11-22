import 'package:flutter/material.dart';

TextTheme buildTextTheme([String? fontFamily]) {
  const FontWeight regular = FontWeight.w400;
  const FontWeight semiBold = FontWeight.w600;
  const FontWeight bold = FontWeight.w700;

  return TextTheme(
    headlineLarge: TextStyle(fontSize: 24, fontWeight: bold, fontFamily: fontFamily),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: semiBold, fontFamily: fontFamily),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: semiBold, fontFamily: fontFamily),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: regular, fontFamily: fontFamily),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: regular, fontFamily: fontFamily),
    bodySmall: TextStyle(fontSize: 12, fontWeight: regular, fontFamily: fontFamily),
    titleMedium: TextStyle(fontSize: 16, fontWeight: semiBold, fontFamily: fontFamily),
    titleSmall: TextStyle(fontSize: 14, fontWeight: semiBold, fontFamily: fontFamily),
    labelLarge: TextStyle(fontSize: 14, fontWeight: semiBold, fontFamily: fontFamily),
  );
}
