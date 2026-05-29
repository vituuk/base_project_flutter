import 'package:get/get.dart';

import '../controllers/setting_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<SettingController>(() => SettingController());
  }
}

class SecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityController>(() => SecurityController());
  }
}

class TwoStepSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TwoStepSecurityController>(() => TwoStepSecurityController());
  }
}

class DevicesSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DevicesSecurityController>(() => DevicesSecurityController());
  }
}

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(() => NotificationsController());
  }
}

class StorageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageController>(() => StorageController());
  }
}

class HelpCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpCenterController>(() => HelpCenterController());
  }
}

class ContactUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUsController>(() => ContactUsController());
  }
}

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController());
  }
}

class AddAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAccountController>(() => AddAccountController());
  }
}

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

class BioPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BioPrivacyController>(() => BioPrivacyController());
  }
}

class BirthdayPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BirthdayPrivacyController>(() => BirthdayPrivacyController());
  }
}

class DisappearingMessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DisappearingMessagesController>(() => DisappearingMessagesController());
  }
}

class InvitesPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvitesPrivacyController>(() => InvitesPrivacyController());
  }
}

class LastSeenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LastSeenController>(() => LastSeenController());
  }
}

class PhoneNumberPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneNumberPrivacyController>(() => PhoneNumberPrivacyController());
  }
}

class ProfilePhotosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePhotosController>(() => ProfilePhotosController());
  }
}
