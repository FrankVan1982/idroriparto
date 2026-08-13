import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Seed solo se il sistema non offre Material You (web, desktop, Android < 12).
const kFallbackSeed = Color(0xFF6750A4);

/// Tinte per le unità: restano dentro la palette You, senza ruotare la tinta.
class SchemeInk {
  static Color forUnit(ColorScheme s, String id) {
    final palette = <Color>[
      s.primary,
      s.tertiary,
      s.secondary,
      s.error,
    ];
    return palette[id.hashCode.abs() % palette.length];
  }
}

class AppTheme {
  static const outfit = 'Outfit';
  static const fraunces = 'Fraunces';

  /// Material You vero: usa lo schema di sistema intero.
  /// Non passare da [ColorScheme.fromSeed] + variante expressive:
  /// quella ruota la tinta e cancella il wallpaper.
  static ColorScheme materialYou(
    ColorScheme? system,
    Brightness brightness,
  ) {
    if (system != null) return system;
    return ColorScheme.fromSeed(
      seedColor: kFallbackSeed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    );
  }

  static ThemeData from(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final text = textTheme(scheme);
    const pill = StadiumBorder();
    final xl = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32),
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
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
        },
      ),
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
          minimumSize: const Size(48, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: pill,
          textStyle: vf(outfit, 16, 600, scheme.onPrimary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size(48, 56),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: pill,
          side: BorderSide(color: scheme.outline),
          textStyle: vf(outfit, 16, 560, scheme.onSurface),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        extendedTextStyle: vf(outfit, 15, 580, scheme.onPrimaryContainer),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        indicatorShape: pill,
        elevation: 0,
        height: 84,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: selected ? 28 : 24,
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
          shape: const WidgetStatePropertyAll(pill),
        ),
      ),
    );
  }

  static TextTheme textTheme(ColorScheme s) {
    return TextTheme(
      displayLarge: display(s, 44, wght: 700, opsz: 48),
      displayMedium: display(s, 34, wght: 680, opsz: 36),
      headlineMedium: display(s, 28, wght: 660, opsz: 28),
      headlineSmall: display(s, 22, wght: 640, opsz: 24),
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
      height: 1.1,
      letterSpacing: -0.7,
      color: s.onSurface,
      fontVariations: [
        FontVariation('wght', wght),
        FontVariation('opsz', opsz),
        const FontVariation('SOFT', 40),
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
