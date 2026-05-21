import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/profile/change_number_controller.dart';

class ChangeNumberBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<ChangeNumberController>(
      () => ChangeNumberController(Get.find<ProfileController>()),
    );
  }
}
