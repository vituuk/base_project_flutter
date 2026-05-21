import 'package:get/get.dart';
import '../../../../core/constants/setting/privacy_constants.dart';
import 'privacy_controller.dart';

class DisappearingMessagesController extends GetxController {
  final selected = PrivacyConstants.defaultDisappearingOption.obs;

  void setOption(String value) {
    selected.value = value;
    // Sync enabled state back to PrivacyController for overview switch
    if (Get.isRegistered<PrivacyController>()) {
      Get.find<PrivacyController>().disappearingMessagesEnabled.value =
          value != PrivacyConstants.defaultDisappearingOption;
    }
  }
}
