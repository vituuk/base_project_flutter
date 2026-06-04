import 'package:get/get.dart';

/// Static constants for all security-related setting screens.
class SecurityConstants {
  const SecurityConstants._();

  // ── Page title ───────────────────────────────────────────────────────────────

  static String get pageTitle => 'Security'.tr;

  // ── Section labels ──────────────────────────────────────────────────────────

  static String get sectionAccountProtection => 'ACCOUNT PROTECTION'.tr;
  static String get sectionDevicesSessions   => 'DEVICES & SESSIONS'.tr;

  // ── Item labels ─────────────────────────────────────────────────────────────

  static String get itemTwoStepVerification   => 'Two-Step Verification'.tr;
  static String get itemSecurityNotifications => 'Security Notifications'.tr;
  static String get itemEmailAlerts           => 'Email Alerts'.tr;
  static String get itemDevices               => 'Devices'.tr;

  // ── Snackbar / dialog strings ────────────────────────────────────────────────

  static String get snackTwoStepTitle   => 'Two-Step Verification'.tr;
  static String get snackDevicesTitle   => 'Devices & Sessions'.tr;
  static String get snackComingSoon     => 'Coming soon'.tr;

  // ── Default values ──────────────────────────────────────────────────────────

  /// Subtitle shown under Two-Step Verification when disabled.
  static String get twoStepOff => 'Off'.tr;

  /// Subtitle shown under Two-Step Verification when enabled.
  static String get twoStepOn  => 'On'.tr;

  /// Default state for Security Notifications toggle.
  static const bool defaultSecurityNotifications = true;

  /// Default state for Email Alerts toggle.
  static const bool defaultEmailAlerts = false;

  /// Default number of active devices / sessions.
  static const int defaultDeviceCount = 3;
}
