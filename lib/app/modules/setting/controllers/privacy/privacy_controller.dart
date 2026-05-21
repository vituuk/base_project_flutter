import 'package:get/get.dart';
import '../../../../core/constants/setting/privacy_constants.dart';
import 'last_seen_controller.dart';
import 'profile_photos_controller.dart';
import 'phone_number_privacy_controller.dart';
import 'bio_privacy_controller.dart';
import 'birthday_privacy_controller.dart';
import 'invites_privacy_controller.dart';
import 'disappearing_messages_controller.dart';

class PrivacyController extends GetxController {
  // ── Direct state (only for the overview page's switch tiles) ─────────────
  final statusEnabled = PrivacyConstants.defaultStatusEnabled.obs;
  final disappearingMessagesEnabled =
      PrivacyConstants.defaultDisappearingEnabled.obs;

  // ── Delegated getters → sub-controllers (registered by PrivacyBinding) ──
  RxString get lastSeen      => Get.find<LastSeenController>().selected;
  RxString get profilePhotos => Get.find<ProfilePhotosController>().selected;
  RxString get phoneNumber   => Get.find<PhoneNumberPrivacyController>().selected;
  RxString get bioPrivacy    => Get.find<BioPrivacyController>().selected;
  RxString get birthdayPrivacy => Get.find<BirthdayPrivacyController>().selected;
  RxString get invites       => Get.find<InvitesPrivacyController>().selected;

  // ── Toggle methods ────────────────────────────────────────────────────────
  void toggleStatus(bool value) => statusEnabled.value = value;

  void toggleDisappearingMessages(bool value) {
    disappearingMessagesEnabled.value = value;
    Get.find<DisappearingMessagesController>().setOption(
      value
          ? PrivacyConstants.disappearingEnabledDefault
          : PrivacyConstants.defaultDisappearingOption,
    );
  }
}
