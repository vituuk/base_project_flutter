/// Static constants for the Theme and general Settings screens.
class SettingConstants {
  const SettingConstants._();

  // ── Theme options ───────────────────────────────────────────────────────────

  /// Available theme mode labels shown in the Theme picker screen.
  static const List<String> themeModes = [
    'Day Mode',
    'Night Mode',
  ];

  /// Default theme mode applied on first launch.
  static const String defaultThemeMode = 'Day Mode';

  // ── Settings section labels ─────────────────────────────────────────────────

  static const String sectionAccount      = 'ACCOUNT';
  static const String sectionChats        = 'CHATS';
  static const String sectionNotifications = 'NOTIFICATIONS';
  static const String sectionStorage      = 'STORAGE';
  static const String sectionInformation  = 'INFORMATION';

  // ── Settings menu item labels ───────────────────────────────────────────────

  static const String itemPrivacy         = 'Privacy';
  static const String itemSecurity        = 'Security';
  static const String itemChangeNumber    = 'Change Number';
  static const String itemTheme           = 'Theme';
  static const String itemNotifications   = 'Message, Group & Call Tones';
  static const String itemStorage         = 'Storage and data';
  static const String itemHelpCenter      = 'Help Center';
  static const String itemContactUs       = 'Contact us';
  static const String itemPrivacyPolicy   = 'Privacy policy';
  static const String itemAddAccount      = 'Add Account';
  static const String itemLogout          = 'Logout';
  static const String itemEditProfile     = 'Edit Profile';

  // ── Dialog / snackbar copy ──────────────────────────────────────────────────

  static const String logoutDialogTitle   = 'Logout';
  static const String logoutDialogBody    = 'Are you sure you want to log out?';
  static const String logoutDialogCancel  = 'Cancel';
  static const String logoutDialogConfirm = 'Logout';
}
