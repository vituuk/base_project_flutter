import 'package:get/get.dart';

import '../controllers/aa_controller.dart';

class AaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AaController>(
      () => AaController(),
    );
  }
}
