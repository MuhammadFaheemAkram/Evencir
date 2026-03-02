import 'package:evencir_project/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';

/// Builds the complete light and dark [ThemeData] for the app.
/// Uses Flutter's recommended [ColorScheme] + [TextTheme] + [ThemeExtension].
class AppTheme {
  AppTheme._();

  static const String _fontFamily = 'Mulish';

  // ─── Dark Theme ─────────────────────────────────────────────
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2A8C82),
      onPrimary: Colors.white,
      secondary: Color(0xFF4A90D9),
      onSecondary: Colors.white,
      surface: Color(0xFF0A0E12),
    ),
    scaffoldBackgroundColor: const Color(0xFF000000),
    textTheme: _buildTextTheme(Brightness.dark),
    extensions: const <ThemeExtension<dynamic>>[AppColorsExtension.dark],
  );

  // ─── Light Theme ────────────────────────────────────────────
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF000000),
      secondary: Color(0xFF3A7BD5),
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1D21),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    textTheme: _buildTextTheme(Brightness.light),
    extensions: const <ThemeExtension<dynamic>>[AppColorsExtension.light],
  );

  // ─── Text Theme ─────────────────────────────────────────────
  /// Builds a [TextTheme] that adapts to the given brightness.
  /// Widgets should use `Theme.of(context).textTheme.xxx` instead of
  /// hard-coded styles.
  static TextTheme _buildTextTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final Color primary = isDark ? Colors.white : const Color(0xFF1A1D21);
    //final Color secondary =
    //    isDark ? const Color(0xFF8A9BAE) : const Color(0xFF5A6A7A);
    //final Color tertiary =
    //    isDark ? const Color(0xFF5A6A7A) : const Color(0xFF8A9BAE);

    return TextTheme(
      // headlineLarge  → big numbers (48)
      headlineLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: primary,
        height: 1.0,
      ),
      // headlineMedium → medium numbers (36)
      headlineMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: primary,
        height: 1.0,
      ),
      // headlineSmall  → section headers (22)
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      // titleLarge     → card titles / heading3 (18)
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      // titleMedium    → subtitle (15)
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: primary,
      ),
      // bodyLarge      → body (14)
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      // bodyMedium     → bodySmall (12)
      bodyMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      // labelLarge     → body bold (14 bold) — use for emphasized body text
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      // labelSmall     → tiny labels (11)
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: primary,
      ),
    );
  }
}
