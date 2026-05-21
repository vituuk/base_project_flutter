import 'package:get/get.dart';
import '../../profile/controllers/profile_controller.dart';

class SettingController extends GetxController {
  late final ProfileController profileController;

  @override
  void onInit() {
    super.onInit();
    try {
      profileController = Get.find<ProfileController>();
    } catch (_) {
      // Fallback in case ProfileController is not registered yet
      profileController = Get.put(ProfileController());
    }
  }

  // Getters & Setters for Theme Mode linked to ProfileController
  RxString get themeModeName => profileController.themeModeName;

  // Forwarding getters to ProfileController to maintain compatibility
  RxString get userName => profileController.userName;
  RxString get avatarUrl => profileController.avatarUrl;
  RxString get username => profileController.username;
  RxString get mobile => profileController.mobile;
  RxString get bio => profileController.bio;
  RxString get status => profileController.status;
  RxBool get isOnline => profileController.isOnline;
  RxString get birthday => profileController.birthday;

  void setThemeMode(String mode) {
    profileController.setThemeMode(mode);
  }
}
