import 'package:get/get.dart';

import '../../../core/constants/auth/auth_constants.dart';
import '../../../routes/app_routes.dart';

class WelcomeController extends GetxController {
  /// The logged-in user's display name shown on the welcome screen.
  final RxString userName = AuthConstants.defaultUserName.obs;

  /// Called when the user taps "Continue" — redirects to login.
  void goToHome() {
    Get.offNamed(AppRoutes.login);
  }
}
