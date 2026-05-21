import 'package:get/get.dart';
import '../../controllers/privacy/privacy_controller.dart';
import '../../controllers/privacy/last_seen_controller.dart';
import '../../controllers/privacy/profile_photos_controller.dart';
import '../../controllers/privacy/phone_number_privacy_controller.dart';
import '../../controllers/privacy/bio_privacy_controller.dart';
import '../../controllers/privacy/birthday_privacy_controller.dart';
import '../../controllers/privacy/invites_privacy_controller.dart';
import '../../controllers/privacy/disappearing_messages_controller.dart';

class PrivacyBinding extends Bindings {
  @override
  void dependencies() {
    // Register all sub-controllers first so PrivacyController can delegate to them
    Get.lazyPut<LastSeenController>(() => LastSeenController());
    Get.lazyPut<ProfilePhotosController>(() => ProfilePhotosController());
    Get.lazyPut<PhoneNumberPrivacyController>(() => PhoneNumberPrivacyController());
    Get.lazyPut<BioPrivacyController>(() => BioPrivacyController());
    Get.lazyPut<BirthdayPrivacyController>(() => BirthdayPrivacyController());
    Get.lazyPut<InvitesPrivacyController>(() => InvitesPrivacyController());
    Get.lazyPut<DisappearingMessagesController>(() => DisappearingMessagesController());
    // Register the overview controller last (depends on sub-controllers above)
    Get.lazyPut<PrivacyController>(() => PrivacyController());
  }
}
