import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_page.dart';
import 'app_routes.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/welcome.dart';
import '../modules/auth/widgets/login.dart';
import '../modules/auth/widgets/verification.dart';
import '../modules/auth/widgets/set_up_profile.dart';
import '../modules/home/widgets/chat_page.dart';
import '../modules/shell/views/shell_page.dart';
import '../modules/shell/bindings/shell_binding.dart';
import '../modules/chats/views/chat_detail_page.dart';
import '../modules/chats/widgets/location_map_page.dart';
import '../modules/chats/widgets/location_picker_page.dart';
import '../modules/chats/bindings/chat_detail_binding.dart';
import '../modules/contact/views/contact_page.dart';
import '../modules/contact/bindings/contact_binding.dart';
import '../modules/user_call/views/user_call_page.dart';
import '../modules/user_call/bindings/user_call_binding.dart';
import '../modules/profile/views/profile_page.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/widgets/edit_info_page.dart';
import '../modules/profile/widgets/set_photo_page.dart';
import '../modules/profile/widgets/edit_name_page.dart';
import '../modules/profile/widgets/change_number_page.dart';
import '../modules/profile/widgets/edit_username_page.dart';
import '../modules/profile/widgets/edit_bio_page.dart';
import '../modules/setting/views/setting_page.dart';
import '../modules/setting/widgets/theme_page.dart';
import '../modules/setting/widgets/privacy_page.dart';
import '../modules/setting/widgets/last_seen_page.dart';
import '../modules/setting/widgets/profile_photos_page.dart';
import '../modules/setting/widgets/phone_number_privacy_page.dart';
import '../modules/setting/widgets/bio_privacy_page.dart';
import '../modules/setting/widgets/birthday_privacy_page.dart';
import '../modules/setting/widgets/invites_privacy_page.dart';
import '../modules/setting/widgets/disappearing_messages_page.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/widgets/security_page.dart';
import '../modules/setting/widgets/two_step_security_page.dart';
import '../modules/setting/widgets/devices_security_page.dart';
import '../modules/setting/widgets/notifications_page.dart';
import '../modules/setting/widgets/ringtone_page.dart';
import '../modules/setting/widgets/storage_data_page.dart';
import '../modules/setting/widgets/help_center_page.dart';
import '../modules/setting/widgets/contact_us_page.dart';
import '../modules/setting/widgets/privacy_policy_page.dart';
import '../modules/setting/widgets/add_account_page.dart';
import '../modules/setting/widgets/choose_country_page.dart';


class AppPages {
  const AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.shell,
      page: () => const ShellPage(),
      binding: ShellBinding(),
    ),
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
    GetPage(
      name: AppRoutes.twoStepVerification,
      page: () => const TwoStepSecurityPage(),
      binding: TwoStepSecurityBinding(),
    ),
    GetPage(
      name: AppRoutes.devices,
      page: () => const DevicesSecurityPage(),
      binding: DevicesSecurityBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsPage(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.ringtone,
      page: () => const RingtonePage(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.storage,
      page: () => const StorageDataPage(),
      binding: StorageBinding(),
    ),
    GetPage(
      name: AppRoutes.helpCenter,
      page: () => const HelpCenterPage(),
      binding: HelpCenterBinding(),
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => const ContactUsPage(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyPage(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: AppRoutes.addAccount,
      page: () => const AddAccountPage(),
      binding: AddAccountBinding(),
    ),
    GetPage(
      name: AppRoutes.chooseCountry,
      page: () => const ChooseCountryPage(),
      binding: AddAccountBinding(),
    ),
    GetPage(
      name: AppRoutes.locationMap,
      page: () => const LocationMapPage(),
    ),
    GetPage(
      name: AppRoutes.locationPicker,
      page: () => const LocationPickerPage(),
    ),
  ];
}
