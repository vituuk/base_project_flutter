import 'package:get/get.dart';
import '../../../../core/constants/setting/privacy_constants.dart';

/// Birthday default is 'Nobody'.
class BirthdayPrivacyController extends GetxController {
  final selected = PrivacyConstants.visibilityOptions[2].obs; // 'Nobody'

  void setOption(String value) {
    selected.value = value;
  }
}
