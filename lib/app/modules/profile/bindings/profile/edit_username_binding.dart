import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/profile/edit_username_controller.dart';

class EditUsernameBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<EditUsernameController>(
      () => EditUsernameController(Get.find<ProfileController>()),
    );
  }
}
