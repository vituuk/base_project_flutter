/// All static string and value constants shared across the auth screens
/// (welcome, login, verification, set-up profile).
class AuthConstants {
  const AuthConstants._();

  // ── Welcome screen ──────────────────────────────────────────────────────────

  /// Placeholder display name shown on the welcome screen.
  static const String defaultUserName = 'Adrian Smith';

  /// Small label above the "Welcome Back" heading.
  static const String welcomeLoginLabel = 'Successful login';

  /// Main heading on the welcome screen (newline-separated).
  static const String welcomeHeading = 'Welcome\nBack';

  /// Body description paragraph on the welcome screen.
  static const String welcomeDescription =
      "It's great to see you again. We've missed having you around. "
      "Everything is ready for you to pick up where you left off.";

  /// Label for the primary CTA button (welcome & set-up profile screens).
  static const String continueLabel = 'Continue';

  /// Duration in milliseconds for the welcome page entrance animation.
  static const int welcomeAnimDurationMs = 900;

  // ── Login screen ────────────────────────────────────────────────────────────

  /// Top subtitle shown above the login card.
  static const String loginSubtitle = 'Sign in to continue your conversations';

  /// Main heading inside the login card.
  static const String loginHeading = 'Enter your Number';

  /// Secondary text inside the login card.
  static const String loginCardSubtitle =
      'Enter your mobile number to receive\na verification code';

  /// Label above the phone input field.
  static const String loginPhoneLabel = 'Phone Number';

  /// Hint text inside the phone number text field.
  static const String loginPhoneHint = 'Mobile number';

  /// Label for the "Verify Code" action button.
  static const String loginVerifyButton = 'Verify Code';

  /// Bottom-link: help center.
  static const String loginHelpCenter = 'Help Center';

  // ── Shared footer links ─────────────────────────────────────────────────────

  /// Shared footer link used on login and verification screens.
  static const String privacyPolicy = 'Privacy Policy';

  /// Footer link used on the verification screen.
  static const String termsOfService = 'Terms of Service';

  // ── Verification / OTP screen ───────────────────────────────────────────────

  /// Default dial code pre-selected in the country picker.
  static const String defaultDialCode = '+855';

  /// Flag emoji for the default country (Cambodia 🇰🇭).
  static const String defaultFlagEmoji = '🇰🇭';

  /// AppBar title on the verification screen.
  static const String verificationTitle = 'Verification';

  /// Card heading on the verification screen.
  static const String verificationHeading = 'Verify Code';

  /// Primary CTA button label on the verification screen.
  static const String verificationButton = 'Verify & Continue';

  /// Resend prompt text.
  static const String verificationResendPrompt = "Didn't receive the code?";

  /// Resend button label.
  static const String verificationResendButton = 'Resend Code';

  /// "Back to " prefix in the sign-in link.
  static const String verificationBackTo = 'Back to ';

  /// Inline link text for returning to the sign-in screen.
  static const String verificationSignIn = 'Sign in';

  /// Number of OTP digit boxes.
  static const int otpLength = 6;

  /// Countdown duration (seconds) before the "Resend" button becomes active.
  static const int otpResendSeconds = 40;

  /// Fallback phone number shown when none is passed via route arguments.
  static const String fallbackPhoneNumber = '+1 (555) 000-0000';

  // ── Set-up profile screen ───────────────────────────────────────────────────

  /// AppBar title on the set-up profile screen.
  static const String setupProfileTitle = 'Set Up Profile';

  /// Card heading on the set-up profile screen.
  static const String setupProfileHeading = 'Set up Profile';

  /// Card subtitle / instruction below the heading.
  static const String setupProfileSubtitle = 'enter your name';

  /// Label for the first-name input field.
  static const String setupFirstNameLabel = 'First Name';

  /// Label for the last-name input field.
  static const String setupLastNameLabel = 'Last Name';

  /// Hint text for both name input fields.
  static const String setupNameHint = 'Enter your name';
}
