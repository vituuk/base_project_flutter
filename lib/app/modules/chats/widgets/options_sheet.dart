import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_detail_controller.dart';

class OptionsSheet extends StatelessWidget {
  const OptionsSheet({super.key, required this.controller});
  final ChatDetailController controller;

  static const Color _primary = Color(0xFF2046E8);
  static const Color _danger = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 4),

            // ── Options list ─────────────────────────────────────────────
            OptionTile(
              icon: Icons.call_rounded,
              iconColor: _primary,
              label: 'Call with group',
              labelColor: _primary,
              onTap: () => Get.back(),
            ),
            OptionTile(
              icon: Icons.push_pin_outlined,
              label: 'Pin',
              onTap: () => Get.back(),
            ),
            OptionTile(
              icon: Icons.notifications_off_outlined,
              label: 'Mute',
              onTap: () => Get.back(),
            ),
            OptionTile(
              icon: Icons.group_add_outlined,
              label: 'Add members',
              onTap: () => Get.back(),
            ),
            OptionTile(
              icon: Icons.mark_chat_unread_outlined,
              label: 'Mark as unread',
              onTap: () => Get.back(),
            ),

            // Divider before destructive actions
            const Divider(height: 1, indent: 20, endIndent: 20),

            OptionTile(
              icon: Icons.exit_to_app_rounded,
              iconColor: _danger,
              label: 'Leave group',
              labelColor: _danger,
              onTap: () => Get.back(),
            ),
            OptionTile(
              icon: Icons.delete_outline_rounded,
              iconColor: _danger,
              label: 'Delete',
              labelColor: _danger,
              onTap: () {
                Get.back(); // close sheet
                _confirmDelete(context);
              },
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete conversation?',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
        ),
        content: Obx(() => Text(
              'This will permanently delete your conversation with ${controller.userName.value}.',
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF6B7280))),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // close dialog
              Get.back(); // go back to chat list
            },
            child: const Text('Delete',
                style: TextStyle(
                    color: Color(0xFFEF4444), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor = const Color(0xFF111827),
    this.labelColor = const Color(0xFF111827),
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
