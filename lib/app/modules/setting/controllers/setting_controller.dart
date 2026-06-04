import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/support_chat_page.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../core/constants/setting/security/security_constants.dart';
import '../../../core/constants/setting/privacy_constants.dart';

class SettingController extends GetxController {
  late final ProfileController profileController;

  final currentLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      profileController = Get.find<ProfileController>();
    } catch (_) {
      // Fallback in case ProfileController is not registered yet
      profileController = Get.put(ProfileController());
    }
    // Initialize currentLanguage
    if (Get.locale?.languageCode == 'km') {
      currentLanguage.value = 'Khmer (ភាសាខ្មែរ)';
    } else {
      currentLanguage.value = 'English';
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

  void showLanguageDialog(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF111827);

    Get.dialog(
      Obx(() => AlertDialog(
            backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'Select Language'.tr,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('English', style: TextStyle(color: textColor)),
                  trailing: currentLanguage.value == 'English'
                      ? const Icon(Icons.check_circle, color: Color(0xFF2046E8))
                      : null,
                  onTap: () {
                    setLanguage('en');
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('Khmer (ភាសាខ្មែរ)', style: TextStyle(color: textColor)),
                  trailing: currentLanguage.value == 'Khmer (ភាសាខ្មែរ)'
                      ? const Icon(Icons.check_circle, color: Color(0xFF2046E8))
                      : null,
                  onTap: () {
                    setLanguage('km');
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('Korean (한국어)', style: TextStyle(color: textColor)),
                  trailing: currentLanguage.value == 'Korean (한국어)'
                      ? const Icon(Icons.check_circle, color: Color(0xFF2046E8))
                      : null,
                  onTap: () {
                    setLanguage('ko');
                    Get.back();
                  },
                ),
              ],
            ),
          )),
    );
  }

  void setLanguage(String languageCode) {
    if (languageCode == 'km') {
      currentLanguage.value = 'Khmer (ភាសាខ្មែរ)';
      Get.updateLocale(const Locale('km', 'KH'));
    } else if (languageCode == 'ko') {
      currentLanguage.value = 'Korean (한국어)';
      Get.updateLocale(const Locale('ko', 'KR'));
    } else {
      currentLanguage.value = 'English';
      Get.updateLocale(const Locale('en', 'US'));
    }
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
    'Hip Hop',
    'Free Style',
  ];

  void toggleMessageNotifications(bool val) => messageNotifications.value = val;
  void toggleGroupsNotifications(bool val) => groupsNotifications.value = val;
  void toggleShowPreviews(bool val) => showPreviews.value = val;
  void toggleInAppSounds(bool val) => inAppSounds.value = val;
  void toggleInChatSounds(bool val) => inChatSounds.value = val;
  void toggleInAppVibrate(bool val) => inAppVibrate.value = val;
  void toggleVibrateWhenRinging(bool val) => vibrateWhenRinging.value = val;

  final isRingtonePermissionGranted = false.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final _ringtoneAssets = const {
    'Horizon Breeze (Default)': 'sounds/breeze.wav',
    'Hip Hop': 'sounds/beat1.mp3',
    'Free Style': 'sounds/freestyle.mp3',
  };

  void setRingtone(String ringtone) {
    if (ringtone == 'Silent') {
      selectedRingtone.value = ringtone;
      _stopSound();
      return;
    }

    if (isRingtonePermissionGranted.value) {
      selectedRingtone.value = ringtone;
      _playSound(ringtone);
    } else {
      _showPermissionDialog(ringtone);
    }
  }

  void _playSound(String ringtone) async {
    final assetPath = _ringtoneAssets[ringtone];
    if (assetPath != null) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(assetPath));
      } catch (e) {
        debugPrint('Error playing ringtone: $e');
      }
    }
  }

  void _stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping ringtone: $e');
    }
  }

  void _showPermissionDialog(String ringtone) {
    final isDarkMode = Get.isDarkMode;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    Get.dialog(
      AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Ringtone Permission',
          style: TextStyle(
            color: textColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'To set this sound, the app needs permission to access system audio settings and configure notification alerts.',
          style: TextStyle(
            color: subtitleColor,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Permission Denied',
                'Unable to set ringtone without permission.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFFEF4444),
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
            child: const Text('Don\'t Allow', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () {
              isRingtonePermissionGranted.value = true;
              selectedRingtone.value = ringtone;
              Get.back();
              _playSound(ringtone);
              Get.snackbar(
                'Permission Granted',
                'Ringtone set to $ringtone successfully.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
            child: const Text(
              'Allow',
              style: TextStyle(
                color: Color(0xFF2046E8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
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
    Get.to(() => const SupportChatPage());
  }

  void sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      query: 'subject=App%20Support%20Request',
    );
    try {
      final launched = await launchUrl(emailLaunchUri);
      if (!launched) {
        Get.snackbar(
          'Notice',
          'No email app found. Are you on an emulator?',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF59E0B),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Notice',
        'No email app configured. Please install an email app.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF59E0B),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void giveFeedback() {
    Get.bottomSheet(
      const _FeedbackBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      ignoreSafeArea: false,
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

// ── Feedback Bottom Sheet ──────────────────────────────────────────────────
class _FeedbackBottomSheet extends StatefulWidget {
  const _FeedbackBottomSheet();

  @override
  State<_FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<_FeedbackBottomSheet> {
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final primary = const Color(0xFF2046E8);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Give Feedback'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help us improve by sharing your thoughts and suggestions.'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: subtitleColor),
          ),
          const SizedBox(height: 24),
          // Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: index < _rating ? const Color(0xFFF59E0B) : subtitleColor,
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          // Text Input
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: TextField(
              controller: _feedbackController,
              maxLines: 4,
              style: TextStyle(color: textColor, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Type your feedback here...',
                hintStyle: TextStyle(color: subtitleColor, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Success',
                  'Thank you for your feedback!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Submit Feedback',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

