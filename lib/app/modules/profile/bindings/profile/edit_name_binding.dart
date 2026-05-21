import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/profile/edit_name_controller.dart';

class EditNameBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<EditNameController>(
      () => EditNameController(Get.find<ProfileController>()),
    );
  }
}
