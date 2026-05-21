import 'package:get/get.dart';
import '../../../../core/constants/setting/privacy_constants.dart';

class LastSeenController extends GetxController {
  final selected = PrivacyConstants.defaultPrivacyOption.obs;

  void setOption(String value) {
    selected.value = value;
  }
}
