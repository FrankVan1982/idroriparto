import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Token di marca. Un solo accento (teal mediterraneo) su carta calda.
/// Vietato #0D1117 + neon. I testi usano onSurface / onSurfaceVariant a contrasto AA.
class AppColors {
  static const deep = Color(0xFF0B3D42);
  static const teal = Color(0xFF0C5C59);
  static const aqua = Color(0xFF1A8F8A);
  static const foam = Color(0xFFD8EFED);
  static const paper = Color(0xFFF3EEE4);
  static const ivory = Color(0xFFFFFCF6);
  static const sand = Color(0xFFE4D6C0);
  static const ink = Color(0xFF122026);
  static const inkSoft = Color(0xFF3E5458);
  static const coral = Color(0xFF9B3A34);
  static const amber = Color(0xFF8A5A18);
  static const sage = Color(0xFF2F5A38);
  static const creamOnDark = Color(0xFFF4EFE4);

  /// Palette unità: tinte scure, leggibili su contenitore chiaro.
  static const unitPalette = <Color>[
    Color(0xFF0C5C59),
    Color(0xFF185A86),
    Color(0xFF8A5A18),
    Color(0xFF5E3F86),
    Color(0xFF9B3A34),
    Color(0xFF2F5A38),
    Color(0xFF0B3D42),
    Color(0xFF8A4B28),
    Color(0xFF1F6B74),
    Color(0xFF6B4038),
  ];

  static Color forUnit(String id) {
    final h = id.hashCode.abs();
    return unitPalette[h % unitPalette.length];
  }

  @Deprecated('Usa ColorScheme.onSurfaceVariant')
  static const muted = inkSoft;

  @Deprecated('Usa ColorScheme.outlineVariant')
  static const line = Color(0xFFD4DCD8);
}

class AppTheme {
  static const outfit = 'Outfit';
  static const fraunces = 'Fraunces';

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.teal,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFC6E8E5),
      onPrimaryContainer: Color(0xFF063532),
      secondary: AppColors.deep,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFD4E4E2),
      onSecondaryContainer: Color(0xFF0B2C30),
      tertiary: AppColors.amber,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFF3E0C0),
      onTertiaryContainer: Color(0xFF3D2706),
      error: AppColors.coral,
      onError: Colors.white,
      errorContainer: Color(0xFFF8D6D3),
      onErrorContainer: Color(0xFF4A1512),
      surface: AppColors.ivory,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.inkSoft,
      surfaceContainerLowest: Color(0xFFFFFDF9),
      surfaceContainerLow: Color(0xFFFAF6EE),
      surfaceContainer: Color(0xFFF3EEE4),
      surfaceContainerHigh: Color(0xFFEBE4D8),
      surfaceContainerHighest: Color(0xFFE4DCD0),
      outline: Color(0xFF7A8A88),
      outlineVariant: Color(0xFFC9D3D1),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF1C2E31),
      onInverseSurface: AppColors.creamOnDark,
      inversePrimary: Color(0xFF8FD4CF),
    );
    return _base(scheme).copyWith(scaffoldBackgroundColor: AppColors.paper);
  }

  static ThemeData get dark {
    // Scuro caldo (pino), non GitHub-dark.
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF8FD4CF),
      onPrimary: Color(0xFF053330),
      primaryContainer: Color(0xFF0C5C59),
      onPrimaryContainer: Color(0xFFD6F3F0),
      secondary: Color(0xFFE4D6C0),
      onSecondary: Color(0xFF2A2114),
      secondaryContainer: Color(0xFF2A3E41),
      onSecondaryContainer: Color(0xFFE8F1F0),
      tertiary: Color(0xFFE8C27A),
      onTertiary: Color(0xFF3A2808),
      tertiaryContainer: Color(0xFF5A3D12),
      onTertiaryContainer: Color(0xFFF8E7C4),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF4A1512),
      errorContainer: Color(0xFF7A2A26),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF1C2E31),
      onSurface: Color(0xFFF2F4F2),
      onSurfaceVariant: Color(0xFFC5D2D0),
      surfaceContainerLowest: Color(0xFF121F21),
      surfaceContainerLow: Color(0xFF182628),
      surfaceContainer: Color(0xFF1E3033),
      surfaceContainerHigh: Color(0xFF26383B),
      surfaceContainerHighest: Color(0xFF2E4245),
      outline: Color(0xFF8A9A98),
      outlineVariant: Color(0xFF3D5154),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE8E6DE),
      onInverseSurface: Color(0xFF1C2E31),
      inversePrimary: AppColors.teal,
    );
    return _base(scheme).copyWith(
      scaffoldBackgroundColor: const Color(0xFF152326),
    );
  }

  static ThemeData _base(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final text = _textTheme(scheme);
    final stadium = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(999),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      fontFamily: outfit,
      textTheme: text,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
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
        color: scheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide.none,
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.secondaryContainer,
        labelStyle: text.labelLarge?.copyWith(color: scheme.onSurface),
        shape: stadium,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
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
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: stadium,
          textStyle: const TextStyle(
            fontFamily: outfit,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: stadium,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(48, 44),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        extendedSizeConstraints: const BoxConstraints(minHeight: 56),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        indicatorShape: stadium,
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
          return TextStyle(
            fontFamily: outfit,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.secondaryContainer,
        indicatorShape: stadium,
        selectedIconTheme: IconThemeData(color: scheme.onSecondaryContainer),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: TextStyle(
          fontFamily: outfit,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontFamily: outfit,
          color: scheme.onSurfaceVariant,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          fontFamily: outfit,
          color: scheme.onInverseSurface,
        ),
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
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: fraunces,
        fontSize: 42,
        height: 1.08,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.1,
        color: scheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontFamily: fraunces,
        fontSize: 32,
        height: 1.12,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.7,
        color: scheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: fraunces,
        fontSize: 26,
        height: 1.18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: scheme.onSurface,
      ),
      headlineSmall: TextStyle(
        fontFamily: fraunces,
        fontSize: 22,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: outfit,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: outfit,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontFamily: outfit,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: outfit,
        fontSize: 16,
        height: 1.45,
        color: scheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: outfit,
        fontSize: 14,
        height: 1.45,
        color: scheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontFamily: outfit,
        fontSize: 12.5,
        height: 1.4,
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontFamily: outfit,
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontFamily: outfit,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}
