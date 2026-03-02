import 'package:flutter/material.dart';

/// Custom color extension for app-specific semantic colors.
/// Access via `Theme.of(context).extension<AppColorsExtension>()!`
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.cardBackground,
    required this.cardBorder,
    required this.teal,
    required this.tealLight,
    required this.green,
    required this.greenLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.dayUnselected,
    required this.daySelectedBorder,
    required this.progressBlue,
    required this.progressGrey,
    required this.navActive,
    required this.navInactive,
    required this.toastBackground,
    required this.buttonText,
  });
  final Color cardBackground;
  final Color cardBorder;
  final Color teal;
  final Color tealLight;
  final Color green;
  final Color greenLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color dayUnselected;
  final Color daySelectedBorder;
  final Color progressBlue;
  final Color progressGrey;
  final Color navActive;
  final Color navInactive;
  final Color toastBackground;
  final Color buttonText;

  @override
  AppColorsExtension copyWith({
    Color? cardBackground,
    Color? cardBorder,
    Color? teal,
    Color? tealLight,
    Color? green,
    Color? greenLight,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? dayUnselected,
    Color? daySelectedBorder,
    Color? progressBlue,
    Color? progressGrey,
    Color? navActive,
    Color? navInactive,
    Color? toastBackground,
    Color? buttonText,
  }) {
    return AppColorsExtension(
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      teal: teal ?? this.teal,
      tealLight: tealLight ?? this.tealLight,
      green: green ?? this.green,
      greenLight: greenLight ?? this.greenLight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      dayUnselected: dayUnselected ?? this.dayUnselected,
      daySelectedBorder: daySelectedBorder ?? this.daySelectedBorder,
      progressBlue: progressBlue ?? this.progressBlue,
      progressGrey: progressGrey ?? this.progressGrey,
      navActive: navActive ?? this.navActive,
      navInactive: navInactive ?? this.navInactive,
      toastBackground: toastBackground ?? this.toastBackground,
      buttonText: buttonText ?? this.buttonText,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      teal: Color.lerp(teal, other.teal, t)!,
      tealLight: Color.lerp(tealLight, other.tealLight, t)!,
      green: Color.lerp(green, other.green, t)!,
      greenLight: Color.lerp(greenLight, other.greenLight, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      dayUnselected: Color.lerp(dayUnselected, other.dayUnselected, t)!,
      daySelectedBorder:
          Color.lerp(daySelectedBorder, other.daySelectedBorder, t)!,
      progressBlue: Color.lerp(progressBlue, other.progressBlue, t)!,
      progressGrey: Color.lerp(progressGrey, other.progressGrey, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
      navInactive: Color.lerp(navInactive, other.navInactive, t)!,
      toastBackground: Color.lerp(toastBackground, other.toastBackground, t)!,
      buttonText: Color.lerp(buttonText, other.buttonText, t)!,
    );
  }

  // ── Dark palette ──
  static const dark = AppColorsExtension(
    cardBackground: Color(0xFF18181C),
    cardBorder: Color(0xFF1E2830),
    teal: Color(0xFF2A8C82),
    tealLight: Color(0xFF3AADA0),
    green: Color(0xFF27AE60),
    greenLight: Color(0xFF4CD964),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF8A9BAE),
    textTertiary: Color(0xFFA4A4A4),
    dayUnselected: Color(0xFF18181C),
    daySelectedBorder: Color(0xFF20B76F),
    progressBlue: Color(0xFF4A90D9),
    progressGrey: Color(0xFF2A3440),
    navActive: Color(0xFFFFFFFF),
    navInactive: Color(0xFF66667E),
    toastBackground: Color(0xFF1A3A3A),
    buttonText: Color(0xFF000000),
  );

  // ── Light palette ──
  static const light = AppColorsExtension(
    cardBackground: Color(0xFFF5F6F8),
    cardBorder: Color(0xFFE0E4EA),
    teal: Color(0xFF1E7A72),
    tealLight: Color(0xFF2B9E93),
    green: Color(0xFF219653),
    greenLight: Color(0xFF3CC55F),
    textPrimary: Color(0xFF1A1D21),
    textSecondary: Color(0xFF5A6A7A),
    textTertiary: Color(0xFFA4A4A4),
    dayUnselected: Color(0xFFE8EBF0),
    daySelectedBorder: Color(0xFF219653),
    progressBlue: Color(0xFF3A7BD5),
    progressGrey: Color(0xFFD8DCE2),
    navActive: Color(0xFF000000),
    navInactive: Color(0xFF66667E),
    toastBackground: Color(0xFFD4EFED),
    buttonText: Color(0xFFFFFFFF),
  );
}

/// Convenience extension on [BuildContext] to quickly access custom colors.
extension AppColorsContext on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
