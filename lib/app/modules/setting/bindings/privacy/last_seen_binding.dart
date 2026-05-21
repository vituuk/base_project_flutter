import 'package:get/get.dart';
import '../../controllers/privacy/last_seen_controller.dart';

class LastSeenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LastSeenController>(() => LastSeenController());
  }
}
