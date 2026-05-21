import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/profile/set_photo_controller.dart';

class SetPhotoBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<SetPhotoController>(
      () => SetPhotoController(Get.find<ProfileController>()),
    );
  }
}
