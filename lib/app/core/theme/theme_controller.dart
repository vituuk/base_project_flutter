import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Global theme controller — single source of truth for ThemeMode.
/// Registered in main() before runApp() so it is always available.
class ThemeController extends GetxController {
  final _themeMode = ThemeMode.light.obs;

  ThemeMode get themeMode => _themeMode.value;

  // Callback to handle animated transition at the root wrapper
  Future<void> Function(Offset tapPosition, ThemeMode newMode)? onThemeChangeTransition;

  Future<void> changeThemeWithAnimation(ThemeMode newMode, Offset? tapPosition) async {
    if (_themeMode.value == newMode) return;

    if (onThemeChangeTransition != null) {
      await onThemeChangeTransition!(tapPosition ?? Offset.zero, newMode);
    } else {
      _themeMode.value = newMode;
      Get.changeThemeMode(newMode);
      update();
    }
  }

  void setThemeModeDirectly(ThemeMode newMode) {
    _themeMode.value = newMode;
    update();
  }

  void setDark() {
    changeThemeWithAnimation(ThemeMode.dark, Offset.zero);
  }

  void setLight() {
    changeThemeWithAnimation(ThemeMode.light, Offset.zero);
  }

  void setByName(String name) {
    final mode = name == 'Night Mode' ? ThemeMode.dark : ThemeMode.light;
    changeThemeWithAnimation(mode, Offset.zero);
  }
}

