import 'package:get/get.dart';
import '../profile_controller.dart';

class EditBioController extends GetxController {
  final ProfileController _profile;
  EditBioController(this._profile);

  String get currentBio => _profile.bio.value;

  void saveBio(String value) {
    _profile.bio.value = value.trim();
  }
}
