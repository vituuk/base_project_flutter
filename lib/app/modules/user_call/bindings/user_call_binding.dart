import 'package:get/get.dart';

import '../controllers/user_call_controller.dart';

class UserCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserCallController>(() => UserCallController());
  }
}
