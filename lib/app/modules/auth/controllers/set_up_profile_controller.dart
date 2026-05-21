import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

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

    Get.offNamed(AppRoutes.chat, arguments: {'name': fullName});
  }
}
