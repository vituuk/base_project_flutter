import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['isSelf'] == false) {
      final tag = args['username'] ?? args['name'];
      Get.lazyPut<ProfileController>(() => ProfileController(), tag: tag);
    } else {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
  }
}

class ChangeNumberBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<ChangeNumberController>(
      () => ChangeNumberController(Get.find<ProfileController>()),
    );
  }
}

class EditBioBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<EditBioController>(
      () => EditBioController(Get.find<ProfileController>()),
    );
  }
}

class EditInfoBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<EditInfoController>(
      () => EditInfoController(Get.find<ProfileController>()),
    );
  }
}

class EditNameBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<EditNameController>(
      () => EditNameController(Get.find<ProfileController>()),
    );
  }
}

class EditUsernameBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<EditUsernameController>(
      () => EditUsernameController(Get.find<ProfileController>()),
    );
  }
}

class SetPhotoBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController());
    }
    Get.lazyPut<SetPhotoController>(
      () => SetPhotoController(Get.find<ProfileController>()),
    );
  }
}