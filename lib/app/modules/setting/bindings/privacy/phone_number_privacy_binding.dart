import 'package:get/get.dart';
import '../../controllers/privacy/phone_number_privacy_controller.dart';

class PhoneNumberPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneNumberPrivacyController>(() => PhoneNumberPrivacyController());
  }
}
