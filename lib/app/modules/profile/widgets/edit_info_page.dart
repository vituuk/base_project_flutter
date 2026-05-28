import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class EditInfoPage extends GetView<EditInfoController> {
  const EditInfoPage({super.key});

  static Color get _primary => AppColors.primary;
  static Color get _bg => AppColors.bg;
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) => Scaffold(
        backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _primary,
              size: 18,
            ),
          ),
        ),
        titleSpacing: 8,
        title: Text(
          'Edit Information',
          style: TextStyle(
            color: _primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'YOUR INFO',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            // Your Info Card
            _buildCard(
              child: Column(
                children: [
                  Obx(() => _buildEditableTile(
                        context: context,
                        icon: Icons.badge_outlined,
                        title: controller.userName.value,
                        subtitle: 'Your name',
                        onTap: () => Get.toNamed(AppRoutes.editName),
                      )),
                  Divider(height: 1, thickness: 0.5, color: AppColors.divider, indent: 52),
                  Obx(() => _buildEditableTile(
                        context: context,
                        icon: Icons.phone_outlined,
                        title: controller.mobile.value,
                        subtitle: 'Tap to change phone number',
                        onTap: () => Get.toNamed(AppRoutes.changeNumber),
                      )),
                  Divider(height: 1, thickness: 0.5, color: AppColors.divider, indent: 52),
                  Obx(() => _buildEditableTile(
                        context: context,
                        icon: Icons.alternate_email_rounded,
                        title: controller.username.value,
                        subtitle: 'Username',
                        onTap: () => Get.toNamed(AppRoutes.editUsername),
                      )),
                  Divider(height: 1, thickness: 0.5, color: AppColors.divider, indent: 52),
                  Obx(() => _buildEditableTile(
                        context: context,
                        icon: Icons.cake_outlined,
                        title: controller.birthday.value,
                        subtitle: 'Birthday',
                        onTap: () => _showBirthdayPicker(context),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'YOUR BIO',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            // Your Bio Card
            _buildCard(
              child: Obx(() => _buildEditableTile(
                    context: context,
                    icon: Icons.notes_rounded,
                    title: controller.bio.value.isEmpty ? 'Write about yourself...' : controller.bio.value,
                    subtitle: 'Bio',
                    onTap: () => Get.toNamed(AppRoutes.editBio),
                  )),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildEditableTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _primary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: _darkText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: _subtitleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.touch_app_outlined,
              color: Color(0xFF6B7280),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }


  void _showBirthdayPicker(BuildContext context) {
    DateTime selectedDate = DateTime(2009, 2, 1);
    try {
      final parts = controller.birthday.value.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        selectedDate = DateTime(year, month, day);
      }
    } catch (_) {}

    DateTime tempDate = selectedDate;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 380,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Birthday',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    cupertinoOverrideTheme: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          color: AppColors.text,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: selectedDate,
                    maximumDate: DateTime.now(),
                    minimumYear: 1900,
                    maximumYear: DateTime.now().year,
                    onDateTimeChanged: (DateTime newDate) {
                      tempDate = newDate;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final dayStr = tempDate.day.toString().padLeft(2, '0');
                      final monthStr = tempDate.month.toString().padLeft(2, '0');
                       controller.saveBirthday("$dayStr/$monthStr/${tempDate.year}");
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
