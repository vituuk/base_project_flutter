import 'package:get/get.dart';
import '../profile_controller.dart';

class SetPhotoController extends GetxController {
  final ProfileController _profile;
  SetPhotoController(this._profile);

  RxString get avatarUrl => _profile.avatarUrl;

  void saveAvatar(String url) {
    _profile.avatarUrl.value = url;
  }
}
