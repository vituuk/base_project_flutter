import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/chat_detail_controller.dart';
import 'action_button.dart';
import 'options_sheet.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ChatDetailController controller;

  const ChatAppBar({super.key, required this.controller});

  Color get _bg => AppColors.bg;
  Color get _primary => AppColors.primary;
  Color get _darkText => AppColors.text;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _darkText,
            size: 20,
          ),
        ),
      ),
      title: Obx(() => GestureDetector(
        onTap: () {
          Get.toNamed(
            AppRoutes.profile,
            arguments: {
              'isSelf': false,
              'name': controller.userName.value,
              'avatarUrl': controller.avatarUrl.value,
              'isOnline': controller.isOnline.value,
              'username': '@${controller.userName.value.toLowerCase().replaceAll(' ', '_')}',
              'mobile': controller.userName.value == 'Alex Rivera' ? '+855 12777333' : '+855 12888999',
              'bio': 'Hi',
              'status': controller.isOnline.value ? 'online' : 'last seen recently',
            },
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            // Avatar with online dot
            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE8ECF5), width: 1.5),
                  ),
                  child: ClipOval(
                    child: controller.avatarUrl.value.isNotEmpty
                        ? Image.network(
                            controller.avatarUrl.value,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => CircleAvatar(
                              backgroundColor: const Color(0xFFDDE6F9),
                              child: Icon(Icons.person_rounded, color: _primary, size: 22),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: const Color(0xFFDDE6F9),
                            child: Icon(Icons.person_rounded, color: _primary, size: 22),
                          ),
                  ),
                ),
                if (controller.isOnline.value)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.userName.value,
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (controller.isOnline.value)
                  const Text(
                    'Active now',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ],
        ),
      )),
      actions: [
        ActionButton(
          svgPath: 'assets/icons/camera.svg',
          width: 20,
          height: 20,
          onTap: () => controller.startCall(true),
        ),
        const SizedBox(width: 14),
        ActionButton(
          svgPath: 'assets/icons/call.svg',
          width: 18,
          height: 18,
          onTap: () => controller.startCall(false),
        ),
        const SizedBox(width: 14),
        ActionButton(
          svgPath: 'assets/icons/search.svg',
          width: 16,
          height: 16,
          onTap: () {},
        ),
        const SizedBox(width: 10),
        // More options
        Builder(
          builder: (ctx) => GestureDetector(
            onTap: () => _showOptionsSheet(ctx),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.more_vert_rounded, color: _darkText, size: 22),
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => OptionsSheet(controller: controller),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
