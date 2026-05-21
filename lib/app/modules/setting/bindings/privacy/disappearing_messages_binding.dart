import 'package:get/get.dart';
import '../../controllers/privacy/disappearing_messages_controller.dart';

class DisappearingMessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DisappearingMessagesController>(() => DisappearingMessagesController());
  }
}
