import 'package:get/get.dart';

import '../controllers/list_menu_controller.dart';

class ListMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListMenuController>(() => ListMenuController());
  }
}
