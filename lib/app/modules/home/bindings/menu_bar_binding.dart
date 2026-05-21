import 'package:get/get.dart';

import '../controllers/menu_bar_controller.dart';

class MenuBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuBarController>(() => MenuBarController());
  }
}
