import 'package:get/get.dart';
import '../profile_controller.dart';

class EditUsernameController extends GetxController {
  final ProfileController _profile;
  EditUsernameController(this._profile);

  String get currentUsername => _profile.username.value;

  void saveUsername(String value) {
    _profile.username.value = value.trim();
  }
}
