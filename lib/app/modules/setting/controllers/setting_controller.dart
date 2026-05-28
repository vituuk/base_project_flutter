import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../profile/controllers/profile_controller.dart';
import '../../../core/constants/setting/security/security_constants.dart';
import '../../../core/constants/setting/privacy_constants.dart';

class SettingController extends GetxController {
  late final ProfileController profileController;

  @override
  void onInit() {
    super.onInit();
    try {
      profileController = Get.find<ProfileController>();
    } catch (_) {
      // Fallback in case ProfileController is not registered yet
      profileController = Get.put(ProfileController());
    }
  }

  // Getters & Setters for Theme Mode linked to ProfileController
  RxString get themeModeName => profileController.themeModeName;

  // Forwarding getters to ProfileController to maintain compatibility
  RxString get userName => profileController.userName;
  RxString get avatarUrl => profileController.avatarUrl;
  RxString get username => profileController.username;
  RxString get mobile => profileController.mobile;
  RxString get bio => profileController.bio;
  RxString get status => profileController.status;
  RxBool get isOnline => profileController.isOnline;
  RxString get birthday => profileController.birthday;

  void setThemeMode(String mode) {
    profileController.setThemeMode(mode);
  }
}

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

class PrivacyController extends GetxController {
  // ── Direct state (only for the overview page's switch tiles) ─────────────
  final statusEnabled = PrivacyConstants.defaultStatusEnabled.obs;
  final disappearingMessagesEnabled =
      PrivacyConstants.defaultDisappearingEnabled.obs;

  // ── Delegated getters → sub-controllers (registered by PrivacyBinding) ──
  RxString get lastSeen      => Get.find<LastSeenController>().selected;
  RxString get profilePhotos => Get.find<ProfilePhotosController>().selected;
  RxString get phoneNumber   => Get.find<PhoneNumberPrivacyController>().selected;
  RxString get bioPrivacy    => Get.find<BioPrivacyController>().selected;
  RxString get birthdayPrivacy => Get.find<BirthdayPrivacyController>().selected;
  RxString get invites       => Get.find<InvitesPrivacyController>().selected;

  // ── Toggle methods ────────────────────────────────────────────────────────
  void toggleStatus(bool value) => statusEnabled.value = value;

  void toggleDisappearingMessages(bool value) {
    disappearingMessagesEnabled.value = value;
    Get.find<DisappearingMessagesController>().setOption(
      value
          ? PrivacyConstants.disappearingEnabledDefault
          : PrivacyConstants.defaultDisappearingOption,
    );
  }
}

class BioPrivacyController extends GetxController {
  final selected = PrivacyConstants.defaultPrivacyOption.obs;

  void setOption(String value) {
    selected.value = value;
  }
}

class BirthdayPrivacyController extends GetxController {
  final selected = PrivacyConstants.visibilityOptions[2].obs; // 'Nobody'

  void setOption(String value) {
    selected.value = value;
  }
}

class DisappearingMessagesController extends GetxController {
  final selected = PrivacyConstants.defaultDisappearingOption.obs;

  void setOption(String value) {
    selected.value = value;
    // Sync enabled state back to PrivacyController for overview switch
    if (Get.isRegistered<PrivacyController>()) {
      Get.find<PrivacyController>().disappearingMessagesEnabled.value =
          value != PrivacyConstants.defaultDisappearingOption;
    }
  }
}

class InvitesPrivacyController extends GetxController {
  final selected = PrivacyConstants.defaultPrivacyOption.obs;

  void setOption(String value) {
    selected.value = value;
  }
}

class LastSeenController extends GetxController {
  final selected = PrivacyConstants.defaultPrivacyOption.obs;

  void setOption(String value) {
    selected.value = value;
  }
}

class PhoneNumberPrivacyController extends GetxController {
  final selected = PrivacyConstants.visibilityOptions[1].obs; // 'My Contacts'

  void setOption(String value) {
    selected.value = value;
  }
}

class ProfilePhotosController extends GetxController {
  final selected = PrivacyConstants.visibilityOptions[1].obs; // 'My Contacts'

  void setOption(String value) {
    selected.value = value;
  }
}
