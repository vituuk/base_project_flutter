import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/chat_detail_controller.dart';

class AttachmentOverlay extends StatelessWidget {
  final ChatDetailController controller;

  const AttachmentOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double emojiPickerHeight = controller.showEmojiPicker.value ? 280.0 : 0.0;
    final double bottomPadding = MediaQuery.of(context).padding.bottom + 64.0 + keyboardHeight + emojiPickerHeight;

    return Positioned(
      bottom: bottomPadding,
      left: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOverlayPill(
            icon: Icons.location_on_rounded,
            label: 'Location',
            onTap: () async {
              controller.showAttachmentOverlay.value = false;
              final result = await Get.toNamed(AppRoutes.locationPicker);
              if (result != null && result is Map<String, dynamic>) {
                final double lat = result['latitude'];
                final double lng = result['longitude'];
                final String address = result['address'];
                final mapUrl = 'https://maps.google.com/?q=$lat,$lng';

                controller.messages.add(ChatDetailMessage(
                  text: '📍 Location Shared\n$address\n$mapUrl',
                  isSent: true,
                  time: controller.currentTime(),
                  isRead: false,
                ));
                controller.scrollToBottom();
                controller.triggerPeerReply('📍 Location Shared');
              }
            },
          ),
          const SizedBox(height: 8),
          _buildOverlayPill(
            icon: Icons.description_rounded,
            label: 'File',
            onTap: () {
              controller.showAttachmentOverlay.value = false;
              controller.pickAndSendFile();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayPill({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2046E8),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
