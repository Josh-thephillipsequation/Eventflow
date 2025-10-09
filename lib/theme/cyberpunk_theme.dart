import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Neon Dreams 2077 - Cyberpunk Theme
/// Cyan (#00f0ff) + Magenta (#ff00ff) neon aesthetic
class CyberpunkTheme {
  // Core Colors
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonMagenta = Color(0xFFFF00FF);
  static const Color darkBg = Color(0xFF0A0E27);
  static const Color darkBgAlt = Color(0xFF0D1430);
  static const Color textPrimary = Color(0xFFE0E7FF);
  static const Color textMuted = Color(0xFF8B92C7);
  static const Color surface = Color(0xFF0D1430);
  static const Color card = Color(0xFF141B3D);

  static ThemeData get theme {
    const ColorScheme colorScheme = ColorScheme.dark(
      primary: neonCyan,
      secondary: neonMagenta,
      surface: surface,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: textPrimary,
      error: neonMagenta,
      onError: Colors.black,
      // High contrast for selected items
      primaryContainer: Color(0xFF003D44), // Dark cyan for selected backgrounds
      onPrimaryContainer: neonCyan, // Bright cyan text on dark cyan bg
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBg,

      // Cyberpunk typography with monospace feel
      textTheme: GoogleFonts.spaceMonoTextTheme(
        ThemeData.dark().textTheme.apply(
              bodyColor: textPrimary,
              displayColor: textPrimary,
            ),
      ).copyWith(
        headlineLarge: GoogleFonts.spaceMono(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: neonCyan,
        ),
        headlineMedium: GoogleFonts.spaceMono(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: neonCyan,
        ),
        titleLarge: GoogleFonts.spaceMono(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: neonMagenta,
        ),
      ),

      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: darkBg.withOpacity(0.9),
        foregroundColor: neonCyan,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: neonCyan.withOpacity(0.3),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: card,
        shadowColor: neonCyan.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: neonCyan.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonCyan,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          shadowColor: neonCyan.withOpacity(0.5),
          textStyle: GoogleFonts.spaceMono(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: neonCyan.withOpacity(0.1),
        selectedColor: neonCyan.withOpacity(0.3),
        labelStyle: GoogleFonts.spaceMono(
          color: neonCyan,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        side: BorderSide(
          color: neonCyan.withOpacity(0.5),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: neonMagenta,
        foregroundColor: Colors.black,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkBgAlt,
        indicatorColor: neonCyan.withOpacity(0.3),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.spaceMono(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Neon glow box shadows for widgets
  static List<BoxShadow> neonGlow({Color? color, double intensity = 0.5}) {
    final glowColor = color ?? neonCyan;
    return [
      BoxShadow(
        color: glowColor.withOpacity(0.3 * intensity),
        blurRadius: 10,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: glowColor.withOpacity(0.2 * intensity),
        blurRadius: 20,
        spreadRadius: 4,
      ),
    ];
  }

  // Dual neon glow (cyan + magenta)
  static List<BoxShadow> dualNeonGlow({double intensity = 0.5}) {
    return [
      BoxShadow(
        color: neonCyan.withOpacity(0.3 * intensity),
        blurRadius: 10,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: neonMagenta.withOpacity(0.2 * intensity),
        blurRadius: 20,
        spreadRadius: 3,
      ),
    ];
  }
}
