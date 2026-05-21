import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/profile/edit_bio_controller.dart';

class EditBioBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<EditBioController>(
      () => EditBioController(Get.find<ProfileController>()),
    );
  }
}
