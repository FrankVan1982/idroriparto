import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Seed di fallback Material 3 (quando il sistema non espone un accento).
const kFallbackSeed = Color(0xFF6750A4);

/// Palette e tema derivati solo da [ColorScheme] (Material You / accento OS).
class SchemeInk {
  static Color forUnit(ColorScheme s, String id) {
    final hsl = HSLColor.fromColor(s.primary);
    final step = id.hashCode.abs() % 8;
    final hue = (hsl.hue + step * 39) % 360;
    final sat = (hsl.saturation * 0.85 + 0.18).clamp(0.32, 0.72);
    final light = s.brightness == Brightness.dark
        ? (hsl.lightness.clamp(0.52, 0.72))
        : (hsl.lightness.clamp(0.28, 0.46));
    return hsl.withHue(hue).withSaturation(sat).withLightness(light).toColor();
  }
}

class AppTheme {
  static const outfit = 'Outfit';
  static const fraunces = 'Fraunces';

  static ColorScheme schemeFor(Brightness brightness, {Color? seed}) {
    return ColorScheme.fromSeed(
      seedColor: seed ?? kFallbackSeed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.expressive,
    );
  }

  static ThemeData from(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final text = textTheme(scheme);
    final pill = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(999),
    );
    final xl = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      fontFamily: outfit,
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: xl,
      ),
      chipTheme: ChipThemeData(
        side: BorderSide.none,
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.secondaryContainer,
        labelStyle: text.labelLarge?.copyWith(color: scheme.onSurface),
        shape: pill,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: vf(outfit, 14, 460, scheme.onSurfaceVariant),
        hintStyle: vf(outfit, 14, 400, scheme.onSurfaceVariant),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: pill,
          textStyle: vf(outfit, 15, 580, scheme.onPrimary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: pill,
          side: BorderSide(color: scheme.outline),
          textStyle: vf(outfit, 15, 560, scheme.onSurface),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(48, 44),
          textStyle: vf(outfit, 14, 560, scheme.primary),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        extendedTextStyle: vf(outfit, 15, 580, scheme.onPrimaryContainer),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        indicatorShape: pill,
        elevation: 0,
        height: 80,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: selected ? 26 : 24,
            color: selected
                ? scheme.onSecondaryContainer
                : scheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return vf(
            outfit,
            12,
            selected ? 650 : 480,
            selected ? scheme.onSurface : scheme.onSurfaceVariant,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.secondaryContainer,
        indicatorShape: pill,
        selectedIconTheme: IconThemeData(color: scheme.onSecondaryContainer),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: vf(outfit, 12, 650, scheme.onSurface),
        unselectedLabelTextStyle: vf(outfit, 12, 460, scheme.onSurfaceVariant),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: vf(outfit, 14, 460, scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.comfortable,
          shape: WidgetStatePropertyAll(pill),
        ),
      ),
    );
  }

  static TextTheme textTheme(ColorScheme s) {
    return TextTheme(
      displayLarge: display(s, 42, wght: 620, opsz: 48),
      displayMedium: display(s, 32, wght: 600, opsz: 36),
      headlineMedium: display(s, 26, wght: 600, opsz: 28),
      headlineSmall: display(s, 22, wght: 580, opsz: 24),
      titleLarge: vf(outfit, 20, 640, s.onSurface, ls: -0.2),
      titleMedium: vf(outfit, 16, 580, s.onSurface),
      titleSmall: vf(outfit, 14, 580, s.onSurface),
      bodyLarge: vf(outfit, 16, 430, s.onSurface, height: 1.45),
      bodyMedium: vf(outfit, 14, 430, s.onSurface, height: 1.45),
      bodySmall: vf(outfit, 12.5, 430, s.onSurfaceVariant, height: 1.4),
      labelLarge: vf(outfit, 13.5, 580, s.onSurface),
      labelMedium: vf(outfit, 12, 560, s.onSurfaceVariant, ls: 0.4),
    );
  }

  static TextStyle display(
    ColorScheme s,
    double size, {
    required double wght,
    required double opsz,
  }) {
    return TextStyle(
      fontFamily: fraunces,
      fontSize: size,
      height: 1.12,
      letterSpacing: -0.6,
      color: s.onSurface,
      fontVariations: [
        FontVariation('wght', wght),
        FontVariation('opsz', opsz),
        const FontVariation('SOFT', 35),
      ],
    );
  }

  static TextStyle vf(
    String family,
    double size,
    double wght,
    Color color, {
    double height = 1.25,
    double ls = 0,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      height: height,
      letterSpacing: ls,
      color: color,
      fontVariations: [FontVariation('wght', wght)],
    );
  }
}
