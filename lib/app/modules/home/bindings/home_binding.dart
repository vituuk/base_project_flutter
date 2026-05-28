import 'package:get/get.dart';

import '../../../domain/usecases/get_todo.dart';
import '../../../domain/usecases/increment_counter.dart';
import '../controllers/home_controller.dart';

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

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}

class ListMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListMenuController>(() => ListMenuController());
  }
}

class MenuBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuBarController>(() => MenuBarController());
  }
}
