import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/setting/security/security_constants.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../controllers/security/security_controller.dart';

class SecurityPage extends GetView<SecurityController> {
  const SecurityPage({super.key});

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
          SecurityConstants.pageTitle,
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
              // ── ACCOUNT PROTECTION ────────────────────────────────────────────
              _buildSectionHeader(SecurityConstants.sectionAccountProtection),
              _buildCardContainer([
                // Two-Step Verification → with subtitle
                Obx(() => _buildNavTile(
                      icon: Icons.phonelink_lock_rounded,
                      title: SecurityConstants.itemTwoStepVerification,
                      subtitle: controller.twoStepLabel,
                      onTap: () => _showComingSoon(
                        SecurityConstants.snackTwoStepTitle,
                        isDarkMode,
                      ),
                    )),
                _buildDivider(),
                // Security Notifications toggle
                Obx(() => _buildSwitchTile(
                      icon: Icons.notifications_outlined,
                      title: SecurityConstants.itemSecurityNotifications,
                      value: controller.securityNotifications.value,
                      onChanged: controller.toggleSecurityNotifications,
                    )),
                _buildDivider(),
                // Email Alerts toggle
                Obx(() => _buildSwitchTile(
                      icon: Icons.mail_outline_rounded,
                      title: SecurityConstants.itemEmailAlerts,
                      value: controller.emailAlerts.value,
                      onChanged: controller.toggleEmailAlerts,
                    )),
              ]),

              const SizedBox(height: 24),

              // ── DEVICES & SESSIONS ────────────────────────────────────────────
              _buildSectionHeader(SecurityConstants.sectionDevicesSessions),
              _buildCardContainer([
                Obx(() => _buildNavTileWithCount(
                      icon: Icons.devices_rounded,
                      title: SecurityConstants.itemDevices,
                      count: controller.deviceCount.value,
                      onTap: () => _showComingSoon(
                        SecurityConstants.snackDevicesTitle,
                        isDarkMode,
                      ),
                    )),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // ── Private helpers ──────────────────────────────────────────────────────────

  void _showComingSoon(String title, bool isDarkMode) {
    Get.snackbar(
      title,
      SecurityConstants.snackComingSoon,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          isDarkMode ? const Color(0xFF334155) : const Color(0xFF1E293B),
      colorText: Colors.white,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 1),
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
        child: Column(children: children),
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

  /// Arrow tile that shows a subtitle (e.g. "Off" / "On").
  Widget _buildNavTile({
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
            Icon(icon, color: const Color(0xFF475569), size: 22),
            const SizedBox(width: 14),
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
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF94A3B8),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  /// Arrow tile that shows a numeric count badge (e.g. Devices: 3 →).
  Widget _buildNavTileWithCount({
    required IconData icon,
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF475569), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
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

  /// Toggle tile with a Switch widget.
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF475569), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
}
