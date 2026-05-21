import 'package:get/get.dart';
import '../controllers/setting_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<SettingController>(() => SettingController());
  }
}
