import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/auth/auth_constants.dart';
import '../../../routes/app_routes.dart';

class VerificationController extends GetxController {
  /// The phone number passed from login page.
  String phoneNumber = '';

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
    if (Get.arguments != null && Get.arguments is String) {
      phoneNumber = Get.arguments as String;
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

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    // Navigate to set up profile screen after successful verification
    Get.offNamed(AppRoutes.setUpProfile);
  }
}
