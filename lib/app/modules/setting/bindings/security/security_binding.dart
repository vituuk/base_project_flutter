import 'package:get/get.dart';
import '../../controllers/security/security_controller.dart';

class SecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityController>(() => SecurityController());
  }
}
