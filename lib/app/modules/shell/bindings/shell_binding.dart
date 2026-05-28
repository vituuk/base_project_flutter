import 'package:get/get.dart';
import '../controllers/shell_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../contact/controllers/contact_controller.dart';
import '../../setting/bindings/setting_binding.dart';
import '../../profile/controllers/profile_controller.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ShellController>(ShellController(), permanent: true);
    Get.put<ChatController>(ChatController(), permanent: true);
    Get.put<ContactController>(ContactController(), permanent: true);
    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController(), permanent: true);
    }
    SettingBinding().dependencies();
  }
}
