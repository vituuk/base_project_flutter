import 'package:get/get.dart';
import '../../controllers/privacy/invites_privacy_controller.dart';

class InvitesPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvitesPrivacyController>(() => InvitesPrivacyController());
  }
}
