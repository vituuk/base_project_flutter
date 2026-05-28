import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Global theme controller — single source of truth for ThemeMode.
/// Registered in main() before runApp() so it is always available.
class ThemeController extends GetxController {
  final _themeMode = ThemeMode.light.obs;

  ThemeMode get themeMode => _themeMode.value;

  void setDark() {
    _themeMode.value = ThemeMode.dark;
    update();
  }

  void setLight() {
    _themeMode.value = ThemeMode.light;
    update();
  }

  void setByName(String name) {
    if (name == 'Night Mode') {
      _themeMode.value = ThemeMode.dark;
    } else {
      _themeMode.value = ThemeMode.light;
    }
    update();
  }
}

