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

class TwoStepSecurityController extends GetxController {
  final passwordController = TextEditingController();
  final reEnterPasswordController = TextEditingController();

  final obscurePassword = true.obs;
  final obscureReEnterPassword = true.obs;

  void toggleObscurePassword() => obscurePassword.toggle();
  void toggleObscureReEnterPassword() => obscureReEnterPassword.toggle();

  void savePassword() {
    final password = passwordController.text;
    final reEnter = reEnterPasswordController.text;

    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Password cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (password != reEnter) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Save to SecurityController
    if (Get.isRegistered<SecurityController>()) {
      final securityController = Get.find<SecurityController>();
      securityController.twoStepEnabled.value = true;
    }

    Get.back();
    Get.snackbar(
      'Success',
      'Two-step verification has been enabled',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    passwordController.dispose();
    reEnterPasswordController.dispose();
    super.onClose();
  }
}

class DeviceModel {
  final String id;
  final String name;
  final String location;
  final String statusText;
  final bool isCurrent;
  final bool isOnline;
  final IconData icon;

  DeviceModel({
    required this.id,
    required this.name,
    required this.location,
    required this.statusText,
    required this.isCurrent,
    required this.isOnline,
    required this.icon,
  });
}

class DevicesSecurityController extends GetxController {
  // Current device
  final currentDevice = DeviceModel(
    id: 'current',
    name: 'Samsung Galaxy S24 Ultra',
    location: 'Phnom Penh, Cambodia',
    statusText: 'Online',
    isCurrent: true,
    isOnline: true,
    icon: Icons.phone_android_rounded,
  );

  // Linked devices list (reactive)
  final linkedDevices = <DeviceModel>[
    DeviceModel(
      id: 'linked_1',
      name: 'Iphone 15 Pro',
      location: 'Phnom Penh, Cambodia',
      statusText: 'offline 2 hours ago',
      isCurrent: false,
      isOnline: false,
      icon: Icons.phone_android_rounded,
    ),
    DeviceModel(
      id: 'linked_2',
      name: 'MacBook Pro 16"',
      location: 'Phnom Penh, Cambodia',
      statusText: 'offline 6 hours ago',
      isCurrent: false,
      isOnline: false,
      icon: Icons.laptop_mac_rounded,
    ),
  ].obs;

  void terminateDevice(String id) {
    linkedDevices.removeWhere((device) => device.id == id);
    _syncDeviceCount();
  }

  void terminateAllDevices() {
    linkedDevices.clear();
    _syncDeviceCount();
  }

  void _syncDeviceCount() {
    if (Get.isRegistered<SecurityController>()) {
      final securityController = Get.find<SecurityController>();
      securityController.deviceCount.value = linkedDevices.length + 1;
    }
  }
}

class NotificationsController extends GetxController {
  final messageNotifications = true.obs;
  final groupsNotifications = true.obs;
  final showPreviews = false.obs;
  final inAppSounds = false.obs;
  final inChatSounds = false.obs;
  final inAppVibrate = true.obs;
  final selectedRingtone = 'Horizon Breeze (Default)'.obs;
  final vibrateWhenRinging = true.obs;

  final ringtoneOptions = const [
    'Horizon Breeze (Default)',
    'Silent',
    'Comet',
    'Beep-Beep',
    'Chime Time',
  ];

  void toggleMessageNotifications(bool val) => messageNotifications.value = val;
  void toggleGroupsNotifications(bool val) => groupsNotifications.value = val;
  void toggleShowPreviews(bool val) => showPreviews.value = val;
  void toggleInAppSounds(bool val) => inAppSounds.value = val;
  void toggleInChatSounds(bool val) => inChatSounds.value = val;
  void toggleInAppVibrate(bool val) => inAppVibrate.value = val;
  void toggleVibrateWhenRinging(bool val) => vibrateWhenRinging.value = val;

  void setRingtone(String ringtone) {
    selectedRingtone.value = ringtone;
  }
}

class StorageController extends GetxController {
  final storageUsage = '10.2 MB'.obs;
  final changeNumberUsage = '4.8 MB'.obs;
  
  final mobileDataSettings = 'Photos, Audio, Videos, Documents'.obs;
  final wifiSettings = 'Photos, Audio, Videos, Documents'.obs;
  final roamingSettings = 'Photos, Audio, Videos, Documents'.obs;
}

class HelpCenterController extends GetxController {}

class ContactUsController extends GetxController {
  void startLiveChat() {
    Get.snackbar(
      'Live Chat',
      'Connecting to support representative...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2563EB),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void sendEmail() {
    Get.snackbar(
      'Email Support',
      'Opening email composer...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2563EB),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void giveFeedback() {
    Get.snackbar(
      'Feedback',
      'Thank you for your feedback! Opening feedback form...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2563EB),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}

class PrivacyPolicyController extends GetxController {}

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

class CountryModel {
  final String name;
  final String code;
  final String flag;

  const CountryModel({
    required this.name,
    required this.code,
    required this.flag,
  });
}

class AddAccountController extends GetxController {
  final selectedCountry = const CountryModel(name: 'Cambodia', code: '+855', flag: '🇰🇭').obs;
  final phoneController = TextEditingController();

  void selectCountry(CountryModel country) {
    selectedCountry.value = country;
  }

  void addAccount() {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar(
        'Warning',
        'Please enter a mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF59E0B),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final fullNumber = '${selectedCountry.value.code} $phone';
    Get.back(); // Go back to settings page
    Get.snackbar(
      'Account Added',
      'Successfully added account with phone number: $fullNumber',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
