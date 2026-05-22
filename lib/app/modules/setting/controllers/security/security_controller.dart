import 'package:get/get.dart';
import '../../../../core/constants/setting/security/security_constants.dart';

class SecurityController extends GetxController {
  // ── Account Protection state ────────────────────────────────────────────────

  /// Whether Two-Step Verification is enabled.
  final twoStepEnabled = false.obs;

  /// Whether Security Notifications are enabled.
  final securityNotifications =
      SecurityConstants.defaultSecurityNotifications.obs;

  /// Whether Email Alerts are enabled.
  final emailAlerts = SecurityConstants.defaultEmailAlerts.obs;

  // ── Devices & Sessions state ────────────────────────────────────────────────

  /// Number of currently active devices/sessions.
  final deviceCount = SecurityConstants.defaultDeviceCount.obs;

  // ── Derived getters ─────────────────────────────────────────────────────────

  /// Label shown as subtitle under Two-Step Verification.
  String get twoStepLabel =>
      twoStepEnabled.value ? SecurityConstants.twoStepOn : SecurityConstants.twoStepOff;

  // ── Toggle methods ──────────────────────────────────────────────────────────

  void toggleTwoStep(bool value) => twoStepEnabled.value = value;

  void toggleSecurityNotifications(bool value) =>
      securityNotifications.value = value;

  void toggleEmailAlerts(bool value) => emailAlerts.value = value;
}
