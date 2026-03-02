import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// All available SVG icon assets in the app.
enum AppIcon {
  // Mood icons
  happy,
  calm,
  content,
  peaceful,

  // home screen
  notification,
  week,
  arrowDown,
  moon,
  sun,
  rightArrow,

  //Tab bar
  nutrition,
  plan,
  mood,
  profile,

  //plan screen
  drag,
}

/// Helper for resolving and rendering SVG assets by [AppIcon] enum value.
///
/// Usage:
///   AppIcons.svg(AppIcon.moodHappy)
///   AppIcons.svg(AppIcon.moodHappy, size: 48)
///   AppIcons.path(AppIcon.moodHappy) // raw asset path string
class AppIcons {
  AppIcons._();

  static const _basePath = 'assets/icons';

  /// Returns an [SvgPicture] widget for [icon].
  ///
  /// [size]      — sets both width and height when provided.
  /// [width]     — overrides width independently.
  /// [height]    — overrides height independently.
  /// [color]     — applies a color filter (tint).
  /// [fit]       — BoxFit, defaults to [BoxFit.contain].
  static SvgPicture svg(
    AppIcon icon, {
    double size = 24.0,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    Key? key,
  }) {
    return SvgPicture.asset(
      '$_basePath/${icon.name}.svg',
      key: key,
      width: width ?? size,
      height: height ?? size,
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}
