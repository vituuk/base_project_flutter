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
  }
}
