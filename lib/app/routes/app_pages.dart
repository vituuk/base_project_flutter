import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_page.dart';
import 'app_routes.dart';
import '../modules/auth/views/welcome.dart';
import '../modules/auth/bindings/welcome_binding.dart';
import '../modules/auth/views/login.dart';
import '../modules/auth/bindings/login_binding.dart';
import '../modules/auth/views/verification.dart';
import '../modules/auth/bindings/verification_binding.dart';
import '../modules/auth/views/set_up_profile.dart';
import '../modules/auth/bindings/set_up_profile_binding.dart';
import '../modules/home/views/chat_page.dart';
import '../modules/home/bindings/chat_binding.dart';
import '../modules/chats/views/chat_detail_page.dart';
import '../modules/chats/bindings/chat_detail_binding.dart';
import '../modules/contact/views/contact_page.dart';
import '../modules/contact/bindings/contact_binding.dart';
import '../modules/user_call/views/user_call_page.dart';
import '../modules/user_call/bindings/user_call_binding.dart';
import '../modules/profile/views/profile_page.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/bindings/profile/edit_info_binding.dart';
import '../modules/profile/bindings/profile/set_photo_binding.dart';
import '../modules/profile/bindings/profile/edit_name_binding.dart';
import '../modules/profile/bindings/profile/change_number_binding.dart';
import '../modules/profile/bindings/profile/edit_username_binding.dart';
import '../modules/profile/bindings/profile/edit_bio_binding.dart';
import '../modules/profile/views/edit_info_page.dart';
import '../modules/profile/views/set_photo_page.dart';
import '../modules/profile/views/edit_name_page.dart';
import '../modules/profile/views/change_number_page.dart';
import '../modules/profile/views/edit_username_page.dart';
import '../modules/profile/views/edit_bio_page.dart';
import '../modules/setting/views/setting_page.dart';
import '../modules/setting/views/theme_page.dart';
import '../modules/setting/views/privacy/privacy_page.dart';
import '../modules/setting/views/privacy/last_seen_page.dart';
import '../modules/setting/views/privacy/profile_photos_page.dart';
import '../modules/setting/views/privacy/phone_number_privacy_page.dart';
import '../modules/setting/views/privacy/bio_privacy_page.dart';
import '../modules/setting/views/privacy/birthday_privacy_page.dart';
import '../modules/setting/views/privacy/invites_privacy_page.dart';
import '../modules/setting/views/privacy/disappearing_messages_page.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/bindings/privacy/privacy_binding.dart';
import '../modules/setting/bindings/privacy/last_seen_binding.dart';
import '../modules/setting/bindings/privacy/profile_photos_binding.dart';
import '../modules/setting/bindings/privacy/phone_number_privacy_binding.dart';
import '../modules/setting/bindings/privacy/bio_privacy_binding.dart';
import '../modules/setting/bindings/privacy/birthday_privacy_binding.dart';
import '../modules/setting/bindings/privacy/invites_privacy_binding.dart';
import '../modules/setting/bindings/privacy/disappearing_messages_binding.dart';
import '../modules/setting/views/security/security_page.dart';
import '../modules/setting/bindings/security/security_binding.dart';


class AppPages {
  const AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.verification,
      page: () => const VerificationPage(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: AppRoutes.setUpProfile,
      page: () => const SetUpProfilePage(),
      binding: SetUpProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.chatDetail,
      page: () => const ChatDetailPage(),
      binding: ChatDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.contact,
      page: () => const ContactPage(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: AppRoutes.userCall,
      page: () => const UserCallPage(),
      binding: UserCallBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editInfo,
      page: () => const EditInfoPage(),
      binding: EditInfoBinding(),
    ),
    GetPage(
      name: AppRoutes.setPhoto,
      page: () => const SetPhotoPage(),
      binding: SetPhotoBinding(),
    ),
    GetPage(
      name: AppRoutes.editName,
      page: () => const EditNamePage(),
      binding: EditNameBinding(),
    ),
    GetPage(
      name: AppRoutes.changeNumber,
      page: () => const ChangeNumberPage(),
      binding: ChangeNumberBinding(),
    ),
    GetPage(
      name: AppRoutes.editUsername,
      page: () => const EditUsernamePage(),
      binding: EditUsernameBinding(),
    ),
    GetPage(
      name: AppRoutes.editBio,
      page: () => const EditBioPage(),
      binding: EditBioBinding(),
    ),
    GetPage(
      name: AppRoutes.setting,
      page: () => const SettingPage(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.theme,
      page: () => const ThemePage(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.privacy,
      page: () => const PrivacyPage(),
      binding: PrivacyBinding(),
    ),
    GetPage(
      name: AppRoutes.lastSeen,
      page: () => const LastSeenPage(),
      binding: LastSeenBinding(),
    ),
    GetPage(
      name: AppRoutes.profilePhotos,
      page: () => const ProfilePhotosPage(),
      binding: ProfilePhotosBinding(),
    ),
    GetPage(
      name: AppRoutes.phoneNumberPrivacy,
      page: () => const PhoneNumberPrivacyPage(),
      binding: PhoneNumberPrivacyBinding(),
    ),
    GetPage(
      name: AppRoutes.bioPrivacy,
      page: () => const BioPrivacyPage(),
      binding: BioPrivacyBinding(),
    ),
    GetPage(
      name: AppRoutes.birthdayPrivacy,
      page: () => const BirthdayPrivacyPage(),
      binding: BirthdayPrivacyBinding(),
    ),
    GetPage(
      name: AppRoutes.invitesPrivacy,
      page: () => const InvitesPrivacyPage(),
      binding: InvitesPrivacyBinding(),
    ),
    GetPage(
      name: AppRoutes.disappearingMessages,
      page: () => const DisappearingMessagesPage(),
      binding: DisappearingMessagesBinding(),
    ),
    GetPage(
      name: AppRoutes.security,
      page: () => const SecurityPage(),
      binding: SecurityBinding(),
    ),
  ];
}
