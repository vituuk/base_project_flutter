import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/auth/auth_constants.dart';
import '../../../core/constants/auth/country_item.dart';
import '../../../routes/app_routes.dart';

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
