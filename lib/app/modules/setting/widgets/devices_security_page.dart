import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/setting_controller.dart';

class DevicesSecurityPage extends GetView<DevicesSecurityController> {
  const DevicesSecurityPage({super.key});

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
          'Devices',
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
              // ── CURRENT DEVICE SECTION ─────────────────────────────────────
              _buildSectionHeader('CURRENT DEVICE'),
              _buildCardContainer([
                _buildCurrentDeviceItem(controller.currentDevice, isDarkMode),
              ]),

              const SizedBox(height: 24),

              // ── LINKED DEVICES SECTION ─────────────────────────────────────
              Obx(() {
                if (controller.linkedDevices.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('LINKED DEVICES'),
                    _buildCardContainer([
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.linkedDevices.length,
                        separatorBuilder: (context, index) => _buildDivider(),
                        itemBuilder: (context, index) {
                          final device = controller.linkedDevices[index];
                          return _buildLinkedDeviceItem(context, device, isDarkMode);
                        },
                      ),
                      _buildTerminateAllButton(
                        context: context,
                        onTap: () {
                          _showConfirmTerminateDialog(
                            context: context,
                            message: 'You want to terminate all sessions',
                            onConfirm: () => controller.terminateAllDevices(),
                          );
                        },
                      ),
                    ]),
                  ],
                );
              }),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.divider,
      indent: 60,
    );
  }

  Widget _buildCurrentDeviceItem(DeviceModel device, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Icon(
            device.icon,
            color: isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            size: 26,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: device.location),
                      const TextSpan(text: '  '),
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.circle,
                          color: Color(0xFF22C55E),
                          size: 6,
                        ),
                      ),
                      const TextSpan(
                        text: ' Online',
                        style: TextStyle(
                          color: Color(0xFF22C55E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedDeviceItem(BuildContext context, DeviceModel device, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Icon(
            device.icon,
            color: isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            size: 26,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${device.location}  •  ${device.statusText}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildTerminateButton(
            onTap: () {
              _showConfirmTerminateDialog(
                context: context,
                message: 'You want to terminate this device',
                onConfirm: () => controller.terminateDevice(device.id),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTerminateButton({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2), // Light red background
          border: Border.all(color: const Color(0xFFFCA5A5), width: 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Terminate',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.back_hand_rounded,
              color: Color(0xFFEF4444),
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminateAllButton({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          color: Color(0xFFFEE2E2), // Soft red fill
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          border: Border(
            top: BorderSide(color: Color(0xFFFCA5A5), width: 1.0),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terminate All these Sessions',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.back_hand_rounded,
              color: Color(0xFFEF4444),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // ── Confirmation dialog modal ──────────────────────────────────────────────

  void _showConfirmTerminateDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final isDarkModeDialog = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 8,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkModeDialog ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red hand icon with double circles
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFEE2E2), // Outer circle soft pink
                  ),
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFB91C1C), // Inner circle dark red
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.back_hand_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Are you sure?',
                  style: TextStyle(
                    color: isDarkModeDialog ? Colors.white : const Color(0xFF111827),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkModeDialog ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF64748B), // Slate grey/blue
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Get.back(),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB91C1C), // Yes red
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Get.back();
                          onConfirm();
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
