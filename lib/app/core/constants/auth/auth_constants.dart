import 'package:get/get.dart';

class AuthConstants {
  const AuthConstants._();

  static String get defaultUserName => 'Adrian Smith'.tr;
  static String get welcomeLoginLabel => 'Successful login'.tr;
  static String get welcomeHeading => 'Welcome\nBack'.tr;
  static String get welcomeDescription =>
      "It's great to see you again. We've missed having you around. "
      "Everything is ready for you to pick up where you left off.".tr;
  static String get continueLabel => 'Continue'.tr;
  static String get loginSubtitle => 'Sign in to continue your conversations'.tr;
  static String get loginHeading => 'Enter your Number'.tr;
  static String get loginCardSubtitle =>
      'Enter your mobile number to receive\na verification code'.tr;
  static String get loginPhoneLabel => 'Phone Number'.tr;
  static String get loginPhoneHint => 'Mobile number'.tr;
  static String get loginVerifyButton => 'Verify Code'.tr;
  static String get loginHelpCenter => 'Help Center'.tr;
  static String get privacyPolicy => 'Privacy Policy'.tr;
  static String get termsOfService => 'Terms of Service'.tr;
  static const int welcomeAnimDurationMs = 900;
  static const String defaultDialCode = '+855';
  static const String defaultFlagEmoji = '🇰🇭';
  static String get verificationTitle => 'Verification'.tr;
  static String get verificationHeading => 'Verify Code'.tr;
  static String get verificationButton => 'Verify & Continue'.tr;
  static String get verificationResendPrompt => "Didn't receive the code?".tr;
  static String get verificationResendButton => 'Resend Code'.tr;
  static String get verificationBackTo => 'Back to '.tr;
  static String get verificationSignIn => 'Sign in'.tr;
  static const int otpLength = 6;
  static const int otpResendSeconds = 40;
  static String get fallbackPhoneNumber => '+1 (555) 000-0000'.tr;
  static String get setupProfileTitle => 'Set Up Profile'.tr;
  static String get setupProfileHeading => 'Set up Profile'.tr;
  static String get setupProfileSubtitle => 'enter your name'.tr;
  static String get setupFirstNameLabel => 'First Name'.tr;
  static String get setupLastNameLabel => 'Last Name'.tr;
  static String get setupNameHint => 'Enter your name'.tr;
}
