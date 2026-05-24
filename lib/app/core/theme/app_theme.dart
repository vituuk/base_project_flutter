import 'package:flutter/material.dart';
 

class AppTheme {
  const AppTheme._();

  // ── Shared text theme ────────────────────────────────────────────────────────
  //
  // Applies Inter (variable font) across every Material text style.
  // The variable font file covers weights 100–900 so no extra assets needed.

  static const _fontFamily = 'Inter';
  static const fontFamilyInter = 'Inter';
  static const fontFamilyNunito = 'Nunito';

  static TextTheme _textTheme(TextTheme base) => base.copyWith(
        displayLarge: base.displayLarge?.copyWith(fontFamily: _fontFamily),
        displayMedium: base.displayMedium?.copyWith(fontFamily: _fontFamily),
        displaySmall: base.displaySmall?.copyWith(fontFamily: _fontFamily),
        headlineLarge: base.headlineLarge?.copyWith(fontFamily: _fontFamily),
        headlineMedium: base.headlineMedium?.copyWith(fontFamily: _fontFamily),
        headlineSmall: base.headlineSmall?.copyWith(fontFamily: _fontFamily),
        titleLarge: base.titleLarge?.copyWith(fontFamily: _fontFamily),
        titleMedium: base.titleMedium?.copyWith(fontFamily: _fontFamily),
        titleSmall: base.titleSmall?.copyWith(fontFamily: _fontFamily),
        bodyLarge: base.bodyLarge?.copyWith(fontFamily: _fontFamily),
        bodyMedium: base.bodyMedium?.copyWith(fontFamily: _fontFamily),
        bodySmall: base.bodySmall?.copyWith(fontFamily: _fontFamily),
        labelLarge: base.labelLarge?.copyWith(fontFamily: _fontFamily),
        labelMedium: base.labelMedium?.copyWith(fontFamily: _fontFamily),
        labelSmall: base.labelSmall?.copyWith(fontFamily: _fontFamily),
      );



  // ── Light theme ─────────────────────────────────────────────────────────────

  static ThemeData get light {
    const seedColor = Color(0xFF2563EB);
    final base = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      scaffoldBackgroundColor: const Color(0xFFF2F5FC),
      cardColor: Colors.white,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
    return base.copyWith(textTheme: _textTheme(base.textTheme));
  }

  // ── Dark theme ───────────────────────────────────────────────────────────────

  static ThemeData get dark {
    const seedColor = Color(0xFF2563EB);
    final base = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardColor: const Color(0xFF1E293B),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
    return base.copyWith(textTheme: _textTheme(base.textTheme));
  }
}
