import 'package:get/get.dart';
import '../../controllers/privacy/profile_photos_controller.dart';

class ProfilePhotosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePhotosController>(() => ProfilePhotosController());
  }
}
