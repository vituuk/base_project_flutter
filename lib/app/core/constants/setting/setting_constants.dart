import 'package:get/get.dart';

class SettingConstants {
  const SettingConstants._();

  // ── Theme options ───────────────────────────────────────────────────────────

  static List<String> get themeModes => [
    'Day Mode'.tr,
    'Night Mode'.tr,
  ];

  static String get defaultThemeMode => 'Day Mode'.tr;

  // ── Settings section labels ─────────────────────────────────────────────────

  static String get sectionAccount      => 'ACCOUNT'.tr;
  static String get sectionChats        => 'CHATS'.tr;
  static String get sectionNotifications => 'NOTIFICATIONS'.tr;
  static String get sectionStorage      => 'STORAGE'.tr;
  static String get sectionInformation  => 'INFORMATION'.tr;

  // ── Settings menu item labels ───────────────────────────────────────────────

  static String get itemPrivacy         => 'Privacy'.tr;
  static String get itemSecurity        => 'Security'.tr;
  static String get itemChangeNumber    => 'Change Number'.tr;
  static String get itemTheme           => 'Theme'.tr;
  static String get itemNotifications   => 'Notifications'.tr;
  static String get itemNotificationsSubtitle => 'Sounds, Calls, Badges'.tr;
  static String get itemStorage         => 'Storage and data'.tr;
  static String get itemHelpCenter      => 'Help Center'.tr;
  static String get itemContactUs       => 'Contact us'.tr;
  static String get itemPrivacyPolicy   => 'Privacy policy'.tr;
  static String get itemAddAccount      => 'Add Account'.tr;
  static String get itemLogout          => 'Logout'.tr;
  static String get itemEditProfile     => 'Edit Profile'.tr;

  // ── Dialog / snackbar copy ──────────────────────────────────────────────────

  static String get logoutDialogTitle   => 'Logout'.tr;
  static String get logoutDialogBody    => 'Are you sure you want to log out?'.tr;
  static String get logoutDialogCancel  => 'Cancel'.tr;
  static String get logoutDialogConfirm => 'Logout'.tr;
}
