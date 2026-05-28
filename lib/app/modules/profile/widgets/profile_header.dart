import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/profile_controller.dart';
import 'user_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController controller;

  const ProfileHeader({
    super.key,
    required this.controller,
  });

  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;
  static const Color _onlineColor = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelf = controller.isSelf.value;
      return Column(
        children: [
          // Avatar stack
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: UserAvatar(
                    url: controller.avatarUrl.value,
                    errorIconSize: 54,
                  ),
                ),
              ),
              // Online green indicator dot
              if (isSelf || controller.isOnline.value)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _onlineColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Display Name
          Text(
            controller.userName.value,
            style: TextStyle(
              color: _darkText,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),

          // Secondary Info (username or status)
          Builder(builder: (context) {
            if (isSelf) {
              return Column(
                children: [
                  Text(
                    controller.username.value,
                    style: TextStyle(
                      color: _subtitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.status.value,
                    style: TextStyle(
                      color: _onlineColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            } else {
              return Text(
                controller.status.value,
                style: TextStyle(
                  color: _subtitleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );
            }
          }),
        ],
      );
    });
  }
}
