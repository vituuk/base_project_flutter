import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class VerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationController>(() => VerificationController());
  }
}

class SetUpProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetUpProfileController>(() => SetUpProfileController());
  }
}
