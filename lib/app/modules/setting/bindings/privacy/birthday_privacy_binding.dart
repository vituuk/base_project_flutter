import 'package:get/get.dart';
import '../../controllers/privacy/birthday_privacy_controller.dart';

class BirthdayPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BirthdayPrivacyController>(() => BirthdayPrivacyController());
  }
}
