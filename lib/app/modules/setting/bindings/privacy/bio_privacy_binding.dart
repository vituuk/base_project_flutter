import 'package:get/get.dart';
import '../../controllers/privacy/bio_privacy_controller.dart';

class BioPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BioPrivacyController>(() => BioPrivacyController());
  }
}
