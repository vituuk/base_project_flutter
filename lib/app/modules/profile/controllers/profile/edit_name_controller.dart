import 'package:get/get.dart';
import '../profile_controller.dart';

class EditNameController extends GetxController {
  final ProfileController _profile;
  EditNameController(this._profile);

  String get currentName => _profile.userName.value;

  void saveName(String firstName, String lastName) {
    final combined = '$firstName $lastName'.trim();
    _profile.userName.value = combined;
  }
}
