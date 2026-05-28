import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import 'nav_item.dart';

class ProfileBottomNav extends StatelessWidget {
  const ProfileBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                svgPath: 'assets/icons/menu-bar/chat.svg',
                label: 'Chats',
                isActive: false,
                onTap: () => Get.offAllNamed(AppRoutes.chat),
              ),
              NavItem(
                svgPath: 'assets/icons/menu-bar/contact.svg',
                label: 'Contacts',
                isActive: false,
                onTap: () => Get.offAllNamed(AppRoutes.contact),
              ),
              NavItem(
                svgPath: 'assets/icons/menu-bar/setting.svg',
                label: 'Setting',
                isActive: false,
                onTap: () => Get.offAllNamed(AppRoutes.setting),
              ),
              NavItem(
                svgPath: 'assets/icons/menu-bar/profile.svg',
                label: 'Profile',
                isActive: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
