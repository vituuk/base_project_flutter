import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/auth/auth_constants.dart';
import '../../../core/constants/auth/country_item.dart';
import '../../../routes/app_routes.dart';
import '../../profile/controllers/profile_controller.dart';

class WelcomeController extends GetxController {
  /// The logged-in user's display name shown on the welcome screen.
  final RxString userName = AuthConstants.defaultUserName.obs;

  /// Called when the user taps "Continue" — redirects to login.
  void goToHome() {
    Get.offNamed(AppRoutes.login);
  }
}

class LoginController extends GetxController {
  final phoneController = TextEditingController();

  /// Currently selected country dial code shown in the picker.
  final RxString dialCode = AuthConstants.defaultDialCode.obs;

  /// Country flag emoji for the selected dial code.
  final RxString flagEmoji = AuthConstants.defaultFlagEmoji.obs;

  /// Whether the verify-code button is loading.
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  /// Called when user selects a country from the picker sheet.
  void selectCountry(CountryItem country) {
    dialCode.value  = country.dialCode;
    flagEmoji.value = country.flag;
    Get.back(); // close the bottom sheet
  }

  /// Called when user taps "Verify Code".
  Future<void> verifyCode() async {
    final number = phoneController.text.trim();
    if (number.isEmpty) {
      Get.snackbar(
        'Phone number required',
        'Please enter your mobile number.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    // Navigate to verification page, pass phone number as argument
    final fullNumber = '${dialCode.value} $number';
    Get.toNamed(AppRoutes.verification, arguments: fullNumber);
  }
}

class VerificationController extends GetxController {
  /// The phone number passed from login page.
  String phoneNumber = '';

  /// Whether verification is for changing phone number.
  bool isChangeNumber = false;

  /// OTP text controllers — one per digit box.
  final List<TextEditingController> otpControllers =
      List.generate(AuthConstants.otpLength, (_) => TextEditingController());

  /// Focus nodes for auto-advance between boxes.
  final List<FocusNode> focusNodes =
      List.generate(AuthConstants.otpLength, (_) => FocusNode());

  /// Countdown seconds.
  final RxInt secondsLeft = AuthConstants.otpResendSeconds.obs;

  /// Whether the resend button is active.
  final RxBool canResend = false.obs;

  /// Loading state for verify button.
  final RxBool isLoading = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Receive phone number argument
    if (Get.arguments != null) {
      if (Get.arguments is String) {
        phoneNumber = Get.arguments as String;
      } else if (Get.arguments is Map) {
        final args = Get.arguments as Map;
        phoneNumber = args['phoneNumber'] ?? '';
        isChangeNumber = args['isChangeNumber'] ?? false;
      }
    }
    _startTimer();
  }

  @override
  void onClose() {
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    secondsLeft.value = AuthConstants.otpResendSeconds;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
      } else {
        canResend.value = true;
        t.cancel();
      }
    });
  }

  String get formattedTime {
    final m = (secondsLeft.value ~/ 60).toString().padLeft(2, '0');
    final s = (secondsLeft.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Called when a digit is typed in a box — auto-advance focus.
  void onDigitChanged(int index, String value) {
    if (value.length == 1 && index < AuthConstants.otpLength - 1) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String get _otpCode =>
      otpControllers.map((c) => c.text.trim()).join();

  /// Resend code action.
  void resendCode() {
    if (!canResend.value) return;
    for (final c in otpControllers) {
      c.clear();
    }
    focusNodes.first.requestFocus();
    _startTimer();
  }

  /// Verify & Continue action.
  Future<void> verify() async {
    final code = _otpCode;
    if (code.length < AuthConstants.otpLength) {
      Get.snackbar(
        'Incomplete code',
        'Please enter all ${AuthConstants.otpLength} digits.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    if (isChangeNumber) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Green circle with checkmark
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Success',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your phone number has been successfully updated.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF64748B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (Get.isRegistered<ProfileController>()) {
                              Get.find<ProfileController>().mobile.value = phoneNumber;
                            }
                            Get.back(); // close dialog
                            Get.back(); // close verification page
                            Get.back(); // close change number page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } else {
      // Navigate to set up profile screen after successful verification
      Get.offNamed(AppRoutes.setUpProfile);
    }
  }
}

class SetUpProfileController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool hasInput = false.obs;

  @override
  void onInit() {
    super.onInit();
    firstNameController.addListener(_checkInput);
    lastNameController.addListener(_checkInput);
  }

  void _checkInput() {
    hasInput.value = firstNameController.text.trim().isNotEmpty ||
        lastNameController.text.trim().isNotEmpty;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }

  Future<void> continueNext() async {
    final first = firstNameController.text.trim();
    final last = lastNameController.text.trim();
    final fullName = '$first $last'.trim();
    if (first.isEmpty) {
      Get.snackbar(
        'Name required',
        'Please enter your first name.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading.value = false;

    Get.offAllNamed(AppRoutes.shell, arguments: {'name': fullName});
  }
}
