import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class OtherActions extends StatelessWidget {
  final ProfileController controller;

  const OtherActions({
    super.key,
    required this.controller,
  });

  static const Color _primary = Color(0xFF2046E8);
  static Color get _darkText => AppColors.text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          label: 'Chat',
          onTap: () => Get.back(),
        ),
        _buildActionButton(
          icon: Icons.notifications_none_outlined,
          label: 'Mute',
          onTap: () {},
        ),
        _buildActionButton(
          icon: Icons.call_outlined,
          label: 'Call',
          onTap: () => Get.toNamed(
            AppRoutes.userCall,
            arguments: {
              'name': controller.userName.value,
              'avatarUrl': controller.avatarUrl.value,
              'isVideo': false,
            },
          ),
        ),
        _buildActionButton(
          icon: Icons.videocam_outlined,
          label: 'Video',
          onTap: () => Get.toNamed(
            AppRoutes.userCall,
            arguments: {
              'name': controller.userName.value,
              'avatarUrl': controller.avatarUrl.value,
              'isVideo': true,
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 74,
        height: 74,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _primary, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: _darkText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
