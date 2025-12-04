import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Primary
  static const primary500 = Color(0xFF4A8BFF);
  static const primary600 = Color(0xFF3574E5);
  static const primaryLight = Color(0xFFEDF5FF);

  // Secondary
  static const secondary500 = Color(0xFF6C6CE5);

  // Neutral
  static const gray900 = Color(0xFF1A1A1A);
  static const gray700 = Color(0xFF333333);
  static const gray500 = Color(0xFF6B6B6B);
  static const gray300 = Color(0xFFD9D9D9);
  static const gray100 = Color(0xFFF3F3F3);
  static const gray50 = Color(0xFFFAFAFA);

  // Feedback
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFB300);
  static const error = Color(0xFFFF5252);
}

class AppTextStyles {
  const AppTextStyles._();

  /// Title1: 20 / Bold / lh 1.3
  static const title1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// Title2: 18 / SemiBold / lh 1.3
  static const title2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// Body1: 16 / Regular / lh 1.4
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Body2: 14 / Regular / lh 1.4
  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Caption: 12 / Regular / lh 1.3
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );
}

final TextTheme appTextTheme = TextTheme(
  titleLarge: AppTextStyles.title1,
  titleMedium: AppTextStyles.title2,
  bodyLarge: AppTextStyles.body1,
  bodyMedium: AppTextStyles.body2,
  bodySmall: AppTextStyles.caption,
  labelLarge: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
  labelMedium: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500),
);

@immutable
class PolicyTheme extends ThemeExtension<PolicyTheme> {
  const PolicyTheme({
    required this.policyCardRadius,
    required this.policyCardPadding,
    required this.policyTagRadius,
    required this.emptyStateIconColor,
    required this.emptyStateTextColor,
    required this.emptyStateBackgroundColor,
  });

  final double policyCardRadius;
  final EdgeInsets policyCardPadding;
  final double policyTagRadius;
  final Color emptyStateIconColor;
  final Color emptyStateTextColor;
  final Color emptyStateBackgroundColor;

  @override
  PolicyTheme copyWith({
    double? policyCardRadius,
    EdgeInsets? policyCardPadding,
    double? policyTagRadius,
    Color? emptyStateIconColor,
    Color? emptyStateTextColor,
    Color? emptyStateBackgroundColor,
  }) {
    return PolicyTheme(
      policyCardRadius: policyCardRadius ?? this.policyCardRadius,
      policyCardPadding: policyCardPadding ?? this.policyCardPadding,
      policyTagRadius: policyTagRadius ?? this.policyTagRadius,
      emptyStateIconColor: emptyStateIconColor ?? this.emptyStateIconColor,
      emptyStateTextColor: emptyStateTextColor ?? this.emptyStateTextColor,
      emptyStateBackgroundColor:
          emptyStateBackgroundColor ?? this.emptyStateBackgroundColor,
    );
  }

  @override
  PolicyTheme lerp(ThemeExtension<PolicyTheme>? other, double t) {
    if (other is! PolicyTheme) return this;

    return PolicyTheme(
      policyCardRadius: _lerpDouble(policyCardRadius, other.policyCardRadius, t),
      policyCardPadding:
          EdgeInsets.lerp(policyCardPadding, other.policyCardPadding, t) ??
              policyCardPadding,
      policyTagRadius: _lerpDouble(policyTagRadius, other.policyTagRadius, t),
      emptyStateIconColor:
          Color.lerp(emptyStateIconColor, other.emptyStateIconColor, t) ??
              emptyStateIconColor,
      emptyStateTextColor:
          Color.lerp(emptyStateTextColor, other.emptyStateTextColor, t) ??
              emptyStateTextColor,
      emptyStateBackgroundColor: Color.lerp(
            emptyStateBackgroundColor,
            other.emptyStateBackgroundColor,
            t,
          ) ??
          emptyStateBackgroundColor,
    );
  }

  static PolicyTheme light(ColorScheme scheme) => PolicyTheme(
        policyCardRadius: 16.0,
        policyCardPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        policyTagRadius: 14.0,
        emptyStateIconColor: scheme.primary,
        emptyStateTextColor: AppColors.gray500,
        emptyStateBackgroundColor: AppColors.gray50,
      );

  static PolicyTheme dark(ColorScheme scheme) => PolicyTheme(
        policyCardRadius: 16.0,
        policyCardPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        policyTagRadius: 14.0,
        emptyStateIconColor: scheme.primary,
        emptyStateTextColor: scheme.onSurfaceVariant,
        emptyStateBackgroundColor: scheme.surface,
      );
}

double _lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}

CardTheme buildCardTheme(ColorScheme colorScheme, PolicyTheme policyTheme) {
  return CardTheme(
    color: colorScheme.surface,
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(policyTheme.policyCardRadius),
    ),
    shadowColor: colorScheme.shadow,
  );
}

ElevatedButtonThemeData buildElevatedButtonTheme(ColorScheme colorScheme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.body1.copyWith(
        fontWeight: FontWeight.w600,
      ),
      elevation: 1,
    ),
  );
}

OutlinedButtonThemeData buildOutlinedButtonTheme(ColorScheme colorScheme) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(44),
      side: BorderSide(color: colorScheme.outline),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.body2.copyWith(
        fontWeight: FontWeight.w500,
      ),
      foregroundColor: colorScheme.onSurface,
    ),
  );
}

FilledButtonThemeData buildFilledButtonTheme(ColorScheme colorScheme) {
  return FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(44),
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.body2.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

IconButtonThemeData buildIconButtonTheme(ColorScheme colorScheme) {
  return IconButtonThemeData(
    style: IconButton.styleFrom(
      padding: const EdgeInsets.all(8),
      minimumSize: const Size(40, 40),
      shape: const CircleBorder(),
      foregroundColor: colorScheme.onSurfaceVariant,
    ),
  );
}

ChipThemeData buildChipTheme(ColorScheme colorScheme, PolicyTheme policyTheme) {
  return ChipThemeData(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    labelStyle: AppTextStyles.body2.copyWith(
      color: colorScheme.onSurfaceVariant,
    ),
    secondaryLabelStyle: AppTextStyles.body2.copyWith(
      color: colorScheme.primary,
    ),
    backgroundColor: AppColors.gray100,
    disabledColor: AppColors.gray100,
    selectedColor: colorScheme.primaryContainer,
    secondarySelectedColor: colorScheme.primaryContainer,
    checkmarkColor: colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(policyTheme.policyTagRadius),
      side: const BorderSide(color: AppColors.gray100),
    ),
    side: const BorderSide(color: AppColors.gray100),
    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
  );
}

AppBarTheme buildAppBarTheme(ColorScheme colorScheme) {
  return AppBarTheme(
    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTextStyles.title2.copyWith(
      color: colorScheme.onSurface,
    ),
    scrolledUnderElevation: 0,
  );
}

BottomNavigationBarThemeData buildBottomNavigationBarTheme(
  ColorScheme colorScheme,
) {
  return BottomNavigationBarThemeData(
    backgroundColor: colorScheme.surface,
    selectedItemColor: colorScheme.primary,
    unselectedItemColor: AppColors.gray500,
    selectedLabelStyle: AppTextStyles.caption.copyWith(
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: AppTextStyles.caption,
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
    elevation: 8,
  );
}

InputDecorationTheme buildInputDecorationTheme(ColorScheme colorScheme) {
  return InputDecorationTheme(
    filled: true,
    fillColor: colorScheme.surfaceVariant,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.gray100),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
    ),
    hintStyle: AppTextStyles.body2.copyWith(
      color: AppColors.gray500,
    ),
  );
}

class AppTheme {
  const AppTheme._();

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary500,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primary600,
    secondary: AppColors.secondary500,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.primaryLight,
    onSecondaryContainer: AppColors.secondary500,
    tertiary: AppColors.secondary500,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.primaryLight,
    onTertiaryContainer: AppColors.secondary500,
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: Color(0x33FF5252),
    onErrorContainer: AppColors.error,
    surface: Colors.white,
    onSurface: AppColors.gray900,
    surfaceTint: AppColors.primary500,
    surfaceDim: AppColors.gray100,
    surfaceBright: Colors.white,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: AppColors.gray50,
    surfaceContainer: AppColors.gray100,
    surfaceContainerHigh: Color(0xFFE6E6E6),
    surfaceContainerHighest: Color(0xFFDEDEDE),
    onSurfaceVariant: AppColors.gray700,
    outline: AppColors.gray300,
    outlineVariant: AppColors.gray100,
    shadow: Color(0x1F000000),
    scrim: Colors.black,
    inverseSurface: AppColors.gray900,
    onInverseSurface: AppColors.gray50,
    inversePrimary: AppColors.primary600,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary500,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primary600,
    onPrimaryContainer: Colors.white,
    secondary: AppColors.secondary500,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF303355),
    onSecondaryContainer: Colors.white,
    tertiary: AppColors.secondary500,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF303355),
    onTertiaryContainer: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: Color(0xFF7A0000),
    onErrorContainer: AppColors.error,
    surface: Color(0xFF202124),
    onSurface: Colors.white,
    surfaceTint: AppColors.primary500,
    surfaceDim: Color(0xFF191B1F),
    surfaceBright: Color(0xFF2C2E33),
    surfaceContainerLowest: Color(0xFF111318),
    surfaceContainerLow: Color(0xFF171920),
    surfaceContainer: Color(0xFF1D1F26),
    surfaceContainerHigh: Color(0xFF22252C),
    surfaceContainerHighest: Color(0xFF292C33),
    onSurfaceVariant: AppColors.gray300,
    outline: Color(0xFF3D3D3D),
    outlineVariant: Color(0xFF2C2C2C),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Colors.white,
    onInverseSurface: AppColors.gray900,
    inversePrimary: AppColors.primary500,
  );

  static ThemeData get lightTheme => _buildTheme(
        colorScheme: lightColorScheme,
        policyTheme: PolicyTheme.light(lightColorScheme),
      );

  static ThemeData get darkTheme => _buildTheme(
        colorScheme: darkColorScheme,
        policyTheme: PolicyTheme.dark(darkColorScheme),
      );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required PolicyTheme policyTheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: appTextTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: buildAppBarTheme(colorScheme),
      cardTheme: buildCardTheme(colorScheme, policyTheme),
      elevatedButtonTheme: buildElevatedButtonTheme(colorScheme),
      filledButtonTheme: buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: buildOutlinedButtonTheme(colorScheme),
      iconButtonTheme: buildIconButtonTheme(colorScheme),
      chipTheme: buildChipTheme(colorScheme, policyTheme),
      bottomNavigationBarTheme: buildBottomNavigationBarTheme(colorScheme),
      inputDecorationTheme: buildInputDecorationTheme(colorScheme),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: AppTextStyles.title2.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTextStyles.body2.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTextStyles.body2.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerColor: AppColors.gray100,
      splashFactory: InkRipple.splashFactory,
      extensions: <ThemeExtension<dynamic>>[
        policyTheme,
      ],
    );
  }
}
