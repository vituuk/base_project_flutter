import 'package:get/get.dart';

import '../../../domain/usecases/get_todo.dart';
import '../../../domain/usecases/increment_counter.dart';
import '../controllers/home_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/list_menu_controller.dart';
import '../controllers/menu_bar_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        incrementCounter: Get.find<IncrementCounter>(),
        getTodo: Get.find<GetTodo>(),
      ),
    );
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<ListMenuController>(() => ListMenuController());
    Get.lazyPut<MenuBarController>(() => MenuBarController());
  }
}
