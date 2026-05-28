import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/setting_controller.dart';

class PrivacyPage extends GetView<PrivacyController> {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDarkMode ? Colors.white : AppColors.primary,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Text(
          'Privacy',
          style: TextStyle(
            color: isDarkMode ? Colors.white : AppColors.primary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // WHO CAN SEE MY PERSONAL INFO
              _buildSectionHeader('WHO CAN SEE MY PERSONAL INFO'),
              _buildCardContainer([
                _buildOptionTile(
                  icon: Icons.history_rounded,
                  title: 'Last Seen',
                  valueObs: controller.lastSeen,
                  onTap: () => Get.toNamed(AppRoutes.lastSeen),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.incomplete_circle_rounded,
                  title: 'Status',
                  valueObs: controller.statusEnabled,
                  onChanged: controller.toggleStatus,
                ),
                _buildDivider(),
                _buildOptionTile(
                  icon: Icons.account_circle_outlined,
                  title: 'Profile Photos',
                  valueObs: controller.profilePhotos,
                  onTap: () => Get.toNamed(AppRoutes.profilePhotos),
                ),
                _buildDivider(),
                _buildOptionTile(
                  icon: Icons.smartphone_rounded,
                  title: 'Phone Number',
                  valueObs: controller.phoneNumber,
                  onTap: () => Get.toNamed(AppRoutes.phoneNumberPrivacy),
                ),
                _buildDivider(),
                _buildOptionTile(
                  icon: Icons.edit_note_rounded,
                  title: 'BIO',
                  valueObs: controller.bioPrivacy,
                  onTap: () => Get.toNamed(AppRoutes.bioPrivacy),
                ),
                _buildDivider(),
                _buildOptionTile(
                  icon: Icons.cake_outlined,
                  title: 'Birthday',
                  valueObs: controller.birthdayPrivacy,
                  onTap: () => Get.toNamed(AppRoutes.birthdayPrivacy),
                ),
              ]),

              const SizedBox(height: 24),

              // MESSAGES & PRESENCE
              _buildSectionHeader('MESSAGES & PRESENCE'),
              _buildCardContainer([
                _buildSwitchTile(
                  icon: Icons.timer_outlined,
                  title: 'Disappearing Messages',
                  subtitle: 'Start new chats with a timer',
                  valueObs: controller.disappearingMessagesEnabled,
                  onChanged: controller.toggleDisappearingMessages,
                  onTap: () => Get.toNamed(AppRoutes.disappearingMessages),
                ),
                _buildDivider(),
                _buildOptionTile(
                  icon: Icons.people_outline_rounded,
                  title: 'Invites',
                  valueObs: controller.invites,
                  onTap: () => Get.toNamed(AppRoutes.invitesPrivacy),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.divider,
      indent: 54,
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required RxString valueObs,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF475569),
              size: 22,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Obx(() => Text(
                  valueObs.value,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF94A3B8),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required RxBool valueObs,
    required ValueChanged<bool> onChanged,
    VoidCallback? onTap,
  }) {
    final textArea = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xFF475569),
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: onTap != null
                ? InkWell(
                    onTap: onTap,
                    child: textArea,
                  )
                : textArea,
          ),
          const SizedBox(width: 8),
          Obx(() => Switch(
                value: valueObs.value,
                onChanged: onChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCBD5E1),
              )),
        ],
      ),
    );
  }
}
