import 'package:get/get.dart';
import '../../../../core/constants/setting/privacy_constants.dart';

/// Profile Photos default is 'My Contacts' (different from generic 'Everyone').
class ProfilePhotosController extends GetxController {
  final selected = PrivacyConstants.visibilityOptions[1].obs; // 'My Contacts'

  void setOption(String value) {
    selected.value = value;
  }
}
