/// Static constants for all privacy-related setting screens.
class PrivacyConstants {
  const PrivacyConstants._();

  // ── Default selected values ─────────────────────────────────────────────────

  /// Default selection for Last Seen, Profile Photos, Phone Number,
  /// Bio, Birthday, and Invites pickers.
  static const String defaultPrivacyOption = 'Everyone';

  /// Default selection for the Disappearing Messages timer.
  static const String defaultDisappearingOption = 'off';

  /// Default value for the "Status" visibility switch.
  static const bool defaultStatusEnabled = true;

  /// Default value for the "Disappearing Messages" switch on the overview page.
  static const bool defaultDisappearingEnabled = false;

  // ── Option lists ────────────────────────────────────────────────────────────

  /// Standard three-choice visibility options (Last Seen, Profile Photos,
  /// Phone Number, Bio, Birthday, Invites).
  static const List<String> visibilityOptions = [
    'Everyone',
    'My Contacts',
    'Nobody',
  ];

  /// Timer choices for the Disappearing Messages screen.
  static const List<String> disappearingOptions = [
    'off',
    'After 1 day',
    'After 1 week',
    'After 1 month',
    'After 1 year',
  ];

  /// The disappearing value that means "enabled" on the overview toggle.
  static const String disappearingEnabledDefault = 'After 1 day';
}
