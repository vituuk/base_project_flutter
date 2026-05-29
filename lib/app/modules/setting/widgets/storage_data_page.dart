import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/setting_controller.dart';

class StorageDataPage extends GetView<StorageController> {
  const StorageDataPage({super.key});

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
          'Storage and data',
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
              // ── DISK AND NETWORK USAGE SECTION ─────────────────────────────
              _buildSectionHeader('DISK AND NETWORK USAGE'),
              _buildCardContainer([
                Obx(() => _buildNavTile(
                      icon: Icons.incomplete_circle_rounded,
                      title: 'Storage Usage',
                      value: controller.storageUsage.value,
                      onTap: () {},
                    )),
                _buildDivider(),
                Obx(() => _buildNavTile(
                      icon: Icons.bar_chart_rounded,
                      title: 'Change Number',
                      value: controller.changeNumberUsage.value,
                      onTap: () {},
                    )),
              ]),

              const SizedBox(height: 24),

              // ── MEDIA AUTO-DOWNLOAD SECTION ────────────────────────────────
              _buildSectionHeader('MEDIA AUTO-DOWNLOAD'),
              _buildCardContainer([
                Obx(() => _buildDownloadTile(
                      icon: Icons.swap_vert_rounded,
                      title: 'When using mobile data',
                      subtitle: controller.mobileDataSettings.value,
                      onTap: () {},
                    )),
                _buildDivider(),
                Obx(() => _buildDownloadTile(
                      icon: Icons.wifi_rounded,
                      title: 'When using mobile data',
                      subtitle: controller.wifiSettings.value,
                      onTap: () {},
                    )),
                _buildDivider(),
                Obx(() => _buildDownloadTile(
                      icon: Icons.language_rounded,
                      title: 'When using mobile data',
                      subtitle: controller.roamingSettings.value,
                      onTap: () {},
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
      indent: 54,
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
              value,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 6),
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

  Widget _buildDownloadTile({
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
            Icon(
              icon,
              color: const Color(0xFF475569),
              size: 22,
            ),
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
