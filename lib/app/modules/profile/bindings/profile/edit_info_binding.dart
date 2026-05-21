import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/profile/edit_info_controller.dart';

class EditInfoBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<EditInfoController>(
      () => EditInfoController(Get.find<ProfileController>()),
    );
  }
}
