import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension AppThemeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get appBgColor => isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF2F5FC);
  Color get appCardColor => isDarkMode ? const Color(0xFF1E293B) : Colors.white;
  Color get appTextColor => isDarkMode ? Colors.white : const Color(0xFF111827);
  Color get appSubtitleColor => isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
  Color get appDividerColor => isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  Color get appPrimaryColor => isDarkMode ? Colors.white : const Color(0xFF2046E8);
  Color get appInputColor => isDarkMode ? const Color(0xFF1E293B) : Colors.white;
}

class AppColors {
  static bool get isDarkMode => Theme.of(Get.context!).brightness == Brightness.dark;

  static Color get bg => isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF2F5FC);
  static Color get card => isDarkMode ? const Color(0xFF1E293B) : Colors.white;
  static Color get text => isDarkMode ? Colors.white : const Color(0xFF111827);
  static Color get subtitle => isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
  static Color get divider => isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  static Color get primary => isDarkMode ? Colors.white : const Color(0xFF2046E8);
  static Color get input => isDarkMode ? const Color(0xFF1E293B) : Colors.white;
}
