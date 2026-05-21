import 'package:get/get.dart';
import '../profile_controller.dart';

class ChangeNumberController extends GetxController {
  final ProfileController _profile;
  ChangeNumberController(this._profile);

  String get currentPhone => _profile.mobile.value;

  void savePhone(String countryCode, String phone) {
    _profile.mobile.value = '$countryCode $phone'.trim();
  }
}
