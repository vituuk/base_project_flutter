import 'package:get/get.dart';
import '../profile_controller.dart';

class EditInfoController extends GetxController {
  final ProfileController _profile;
  EditInfoController(this._profile);

  RxString get userName => _profile.userName;
  RxString get mobile => _profile.mobile;
  RxString get username => _profile.username;
  RxString get bio => _profile.bio;
  RxString get birthday => _profile.birthday;

  void saveBirthday(String value) {
    _profile.birthday.value = value;
  }
}
