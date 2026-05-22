/// Static constants for all security-related setting screens.
class SecurityConstants {
  const SecurityConstants._();

  // ── Page title ───────────────────────────────────────────────────────────────

  static const String pageTitle = 'Security';

  // ── Section labels ──────────────────────────────────────────────────────────

  static const String sectionAccountProtection = 'ACCOUNT PROTECTION';
  static const String sectionDevicesSessions   = 'DEVICES & SESSIONS';

  // ── Item labels ─────────────────────────────────────────────────────────────

  static const String itemTwoStepVerification   = 'Two-Step Verification';
  static const String itemSecurityNotifications = 'Security Notifications';
  static const String itemEmailAlerts           = 'Email Alerts';
  static const String itemDevices               = 'Devices';

  // ── Snackbar / dialog strings ────────────────────────────────────────────────

  static const String snackTwoStepTitle   = 'Two-Step Verification';
  static const String snackDevicesTitle   = 'Devices & Sessions';
  static const String snackComingSoon     = 'Coming soon';

  // ── Default values ──────────────────────────────────────────────────────────

  /// Subtitle shown under Two-Step Verification when disabled.
  static const String twoStepOff = 'Off';

  /// Subtitle shown under Two-Step Verification when enabled.
  static const String twoStepOn  = 'On';

  /// Default state for Security Notifications toggle.
  static const bool defaultSecurityNotifications = true;

  /// Default state for Email Alerts toggle.
  static const bool defaultEmailAlerts = false;

  /// Default number of active devices / sessions.
  static const int defaultDeviceCount = 3;
}
