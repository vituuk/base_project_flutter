import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/profiles/self_profile_data.dart';

class ProfileController extends GetxController {
  final isSelf = true.obs;
  final userName = ''.obs;
  final avatarUrl = ''.obs;
  final username = ''.obs;
  final mobile = ''.obs;
  final bio = ''.obs;
  final status = ''.obs;
  final isOnline = false.obs;
  final selectedTab = SelfProfileData.defaultTab.obs;
  final birthday = SelfProfileData.birthday.obs;
  final themeModeName = SelfProfileData.defaultThemeMode.obs;

  void setThemeMode(String mode) {
    themeModeName.value = mode;
    if (mode == 'Night Mode') {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      isSelf.value = args['isSelf'] ?? true;
      if (isSelf.value) {
        _setSelfData();
      } else {
        userName.value  = args['name'] ?? '';
        avatarUrl.value = args['avatarUrl'] ?? '';
        username.value  = args['username'] ?? '';
        mobile.value    = args['mobile'] ?? '';
        bio.value       = args['bio'] ?? 'Hi';
        status.value    = args['status'] ?? 'last seen recently';
        isOnline.value  = args['isOnline'] ?? false;
      }
    } else {
      _setSelfData();
    }
  }

  void _setSelfData() {
    isSelf.value    = true;
    userName.value  = SelfProfileData.userName;
    avatarUrl.value = SelfProfileData.avatarUrl;
    username.value  = SelfProfileData.username;
    mobile.value    = SelfProfileData.mobile;
    bio.value       = SelfProfileData.bio;
    status.value    = SelfProfileData.status;
    isOnline.value  = true;
  }
}
