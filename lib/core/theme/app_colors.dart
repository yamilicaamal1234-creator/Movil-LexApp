import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Colores de marca (constantes, no cambian con el tema) ──
  static const emerald = Color(0xFF00B87B);
  static const emeraldDark = Color(0xFF008C5E);
  static const navy = Color(0xFF0A192F);
  static const navySoft = Color(0xFF112240);
  static const background = Color(0xFFF8FAFC);
  static const slate = Color(0xFF64748B);
  static const darkSlate = Color(0xFF94A3B8);
  static const border = Color(0xFFE2E8F0);
  static const darkBorder = Color(0xFF1E3A5F);
  static const orange = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);
  static const blue = Color(0xFF3B82F6);
  static const white = Color(0xFFFFFFFF);

  // ── Colores semánticos (se adaptan a modo claro / oscuro) ──
  /// Se actualiza desde `MaterialApp.builder` según el brillo efectivo.
  static bool isDark = false;

  /// Fondo de pantalla.
  static Color get bg => isDark ? const Color(0xFF071324) : background;

  /// Fondo de tarjetas, hojas y campos.
  static Color get surface => isDark ? navySoft : white;

  /// Texto principal.
  static Color get textPrimary => isDark ? const Color(0xFFF8FAFC) : navy;

  /// Bordes y divisores.
  static Color get line => isDark ? darkBorder : border;

  /// Fondo verde suave para bloques informativos.
  static Color get tint =>
      isDark ? const Color(0xFF0F3A36) : const Color(0xFFE8F8F2);
}
