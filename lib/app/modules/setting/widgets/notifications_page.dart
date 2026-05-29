import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/setting_controller.dart';

class NotificationsPage extends GetView<NotificationsController> {
  const NotificationsPage({super.key});

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
          'Notifications',
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
              // ── MESSAGES SECTION ───────────────────────────────────────────
              _buildSectionHeader('MESSAGES'),
              _buildCardContainer([
                Obx(() => _buildSwitchTile(
                      title: 'Message Notifications',
                      subtitle: 'Receive alerts for new private messages',
                      value: controller.messageNotifications.value,
                      onChanged: controller.toggleMessageNotifications,
                    )),
                _buildDivider(),
                Obx(() => _buildSwitchTile(
                      title: 'Groups Notifications',
                      subtitle: 'Alerts for group activity',
                      value: controller.groupsNotifications.value,
                      onChanged: controller.toggleGroupsNotifications,
                    )),
                _buildDivider(),
                Obx(() => _buildSwitchTile(
                      title: 'Show Previews',
                      subtitle: 'Display message text in notifications',
                      value: controller.showPreviews.value,
                      onChanged: controller.toggleShowPreviews,
                    )),
                _buildDivider(),
                Obx(() => _buildSwitchTile(
                      title: 'In-App Sounds',
                      subtitle: 'Play sound when the app is open',
                      value: controller.inAppSounds.value,
                      onChanged: controller.toggleInAppSounds,
                    )),
                _buildDivider(),
                Obx(() => _buildSwitchTile(
                      title: 'In-Chat Sounds',
                      subtitle: 'Play sounds for incoming and outgoing messages while in a chat',
                      value: controller.inChatSounds.value,
                      onChanged: controller.toggleInChatSounds,
                    )),
                _buildDivider(),
                Obx(() => _buildSwitchTile(
                      title: 'In-App Vibrate',
                      subtitle: 'Vibrate for messages',
                      value: controller.inAppVibrate.value,
                      onChanged: controller.toggleInAppVibrate,
                    )),
              ]),

              const SizedBox(height: 24),

              // ── CALLS SECTION ──────────────────────────────────────────────
              _buildSectionHeader('CALLS'),
              _buildCardContainer([
                Obx(() => _buildNavTile(
                      title: 'Ringtone',
                      subtitle: controller.selectedRingtone.value,
                      onTap: () => Get.toNamed(AppRoutes.ringtone),
                    )),
                _buildDivider(),
                Obx(() => _buildSwitchTile(
                      title: 'Vibrate when ringing',
                      subtitle: 'Enable haptic alerts for incoming calls',
                      value: controller.vibrateWhenRinging.value,
                      onChanged: controller.toggleVibrateWhenRinging,
                    )),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // ── UI Helper Builders ─────────────────────────────────────────────────────

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
      indent: 18,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCBD5E1),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
