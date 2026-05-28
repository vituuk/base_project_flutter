import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/profiles/self_profile_data.dart';
import '../../../core/theme/theme_controller.dart';

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
      if (Get.isRegistered<ThemeController>()) {
        Get.find<ThemeController>().setDark();
      }
    } else {
      Get.changeThemeMode(ThemeMode.light);
      if (Get.isRegistered<ThemeController>()) {
        Get.find<ThemeController>().setLight();
      }
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

class ChangeNumberController extends GetxController {
  final ProfileController _profile;
  ChangeNumberController(this._profile);

  String get currentPhone => _profile.mobile.value;

  void savePhone(String countryCode, String phone) {
    _profile.mobile.value = '$countryCode $phone'.trim();
  }
}

class EditBioController extends GetxController {
  final ProfileController _profile;
  EditBioController(this._profile);

  String get currentBio => _profile.bio.value;

  void saveBio(String value) {
    _profile.bio.value = value.trim();
  }
}

class EditInfoController extends GetxController {
  final ProfileController _profile;
  EditInfoController(this._profile);

  RxString get userName => _profile.userName;
  RxString get mobile => _profile.mobile;
  RxString get username => _profile.username;
  RxString get bio => _profile.bio;
  RxString get birthday => _profile.birthday;

  void saveBirthday(String value) {
    _profile.birthday.value = value;
  }
}

class EditNameController extends GetxController {
  final ProfileController _profile;
  EditNameController(this._profile);

  String get currentName => _profile.userName.value;

  void saveName(String firstName, String lastName) {
    final combined = '$firstName $lastName'.trim();
    _profile.userName.value = combined;
  }
}

class EditUsernameController extends GetxController {
  final ProfileController _profile;
  EditUsernameController(this._profile);

  String get currentUsername => _profile.username.value;

  void saveUsername(String value) {
    _profile.username.value = value.trim();
  }
}

class SetPhotoController extends GetxController {
  final ProfileController _profile;
  SetPhotoController(this._profile);

  RxString get avatarUrl => _profile.avatarUrl;

  void saveAvatar(String url) {
    _profile.avatarUrl.value = url;
  }
}
