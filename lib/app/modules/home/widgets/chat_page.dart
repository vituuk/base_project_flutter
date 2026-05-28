import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/setting/setting_constants.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  // ── Colour palette ──────────────────────────────────────────────────────────
  static Color get _bg => AppColors.bg;
  static Color get _primary => AppColors.primary;
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;
  static Color get _searchBg => AppColors.input;
  static Color get _badgeBg => AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) => Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildSearchBar(),
              const SizedBox(height: 4),
              Expanded(child: _buildMessageList()),
            ],
          ),
        ),
      ),
    );
  }

  // ── App bar ─────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _primary.withOpacity(0.15), width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://randomuser.me/api/portraits/men/46.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => CircleAvatar(
                  backgroundColor: const Color(0xFFDDE6F9),
                  child: Icon(Icons.person_rounded, color: _primary, size: 22),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Messages',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),

              ],
            ),
          ),

          // Add contact icon
          _AppBarIconButton(
            svgPath: 'assets/icons/add-contact.svg',
            onTap: () => Get.toNamed(AppRoutes.contact),
          ),
          const SizedBox(width: 4),
          // More options popup
          _buildDotMenu(context),
        ],
      ),
    );
  }

  // ── Search bar ──────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: _searchBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          onChanged: controller.onSearchChanged,
          style: TextStyle(
            fontSize: 14,
            color: _darkText,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              fontSize: 14,
              color: _subtitleColor,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: _subtitleColor,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 13),
          ),
        ),
      ),
    );
  }

  // ── Message list ────────────────────────────────────────────────────────────
  Widget _buildMessageList() {
    return Obx(() {
      final messages = controller.filteredMessages;
      if (messages.isEmpty) {
        return Center(
          child: Text(
            'No conversations found',
            style: TextStyle(color: _subtitleColor, fontSize: 14),
          ),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: messages.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          thickness: 0.5,
          color: AppColors.divider,
        ),
        itemBuilder: (context, index) =>
            _ChatTile(message: messages[index]),
      );
    });
  }

  // ── Dot menu popup ──────────────────────────────────────────────────────────
  Widget _buildDotMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final dividerColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE8ECF5);
    const Color primary = Color(0xFF2046E8);

    return PopupMenuButton<String>(
      offset: const Offset(0, 44),
      color: cardColor,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      // ── Trigger button (same style as _AppBarIconButton) ─────────────────
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/dot.svg',
            width: 20,
            height: 20,
            colorFilter:
                ColorFilter.mode(AppColors.text, BlendMode.srcIn),
          ),
        ),
      ),
      onSelected: (value) {
        switch (value) {
          case 'day_mode':
            if (Get.isRegistered<ProfileController>()) {
              Get.find<ProfileController>().setThemeMode('Day Mode');
            } else {
              Get.changeThemeMode(ThemeMode.light);
              if (Get.isRegistered<ThemeController>()) {
                Get.find<ThemeController>().setLight();
              }
            }
            break;
          case 'night_mode':
            if (Get.isRegistered<ProfileController>()) {
              Get.find<ProfileController>().setThemeMode('Night Mode');
            } else {
              Get.changeThemeMode(ThemeMode.dark);
              if (Get.isRegistered<ThemeController>()) {
                Get.find<ThemeController>().setDark();
              }
            }
            break;
          case 'new_group':
            Get.toNamed(AppRoutes.contact);
            break;
          case 'settings':
            Get.offAllNamed(AppRoutes.setting);
            break;
        }
      },
      itemBuilder: (_) => [
        // ── Section label ────────────────────────────────────────────────
        PopupMenuItem<String>(
          enabled: false,
          height: 30,
          child: Text(
            'THEME',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: subtitleColor,
            ),
          ),
        ),
        // Day Mode
        PopupMenuItem<String>(
          value: 'day_mode',
          height: 44,
          child: Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                size: 18,
                color: isDark ? subtitleColor : primary,
              ),
              const SizedBox(width: 12),
              Text(
                SettingConstants.themeModes[0],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isDark ? FontWeight.w400 : FontWeight.w600,
                  color: isDark ? textColor : primary,
                ),
              ),
              if (!isDark) ...[
                const Spacer(),
                Icon(Icons.check_rounded, size: 16, color: primary),
              ],
            ],
          ),
        ),
        // Night Mode
        PopupMenuItem<String>(
          value: 'night_mode',
          height: 44,
          child: Row(
            children: [
              Icon(
                Icons.nights_stay_outlined,
                size: 18,
                color: isDark ? primary : subtitleColor,
              ),
              const SizedBox(width: 12),
              Text(
                SettingConstants.themeModes[1],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isDark ? FontWeight.w600 : FontWeight.w400,
                  color: isDark ? primary : textColor,
                ),
              ),
              if (isDark) ...[
                const Spacer(),
                Icon(Icons.check_rounded, size: 16, color: primary),
              ],
            ],
          ),
        ),

        // ── Divider ──────────────────────────────────────────────────────
        PopupMenuItem<String>(
          enabled: false,
          height: 1,
          padding: EdgeInsets.zero,
          child: Divider(height: 1, thickness: 0.5, color: dividerColor),
        ),

        // ── Actions ──────────────────────────────────────────────────────
        PopupMenuItem<String>(
          value: 'new_group',
          height: 44,
          child: Row(
            children: [
              Icon(Icons.group_add_outlined, size: 18, color: subtitleColor),
              const SizedBox(width: 12),
              Text(
                'New Group',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textColor),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          height: 44,
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 18, color: subtitleColor),
              const SizedBox(width: 12),
              Text(
                'Settings',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// ── AppBar Icon Button ────────────────────────────────────────────────────────────
class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({required this.svgPath, required this.onTap});

  final String svgPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(AppColors.text, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

// ── Chat Tile ──────────────────────────────────────────────────────────────────
class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.message});

  final ChatListItem message;

  static Color get _primary => AppColors.primary;
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;
  static Color get _timeColor => AppColors.subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        AppRoutes.chatDetail,
        arguments: {
          'name': message.name,
          'avatarUrl': message.avatarUrl,
          'isOnline': message.isOnline,
        },
      ),
      onLongPress: () => _showOptions(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar with optional online dot ────────────────────────
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.divider, width: 1.0),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      message.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFDDE6F9),
                        child: Icon(Icons.person_rounded,
                            color: _primary, size: 28),
                      ),
                    ),
                  ),
                ),
                if (message.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // ── Name + Message ─────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _darkText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Time
                      Text(
                        message.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: _timeColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          message.lastMessage,
                          style: TextStyle(
                            fontSize: 13,
                            color: _subtitleColor,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (message.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            message.unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Nav Item ────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.svgPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String svgPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  static const Color _primary = Color(0xFF2046E8);
  static const Color _inactive = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    final color = isActive ? _primary : _inactive;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Chat Options Sheet (long-press) ───────────────────────────────────────────────
extension _ChatTileOptions on _ChatTile {
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.25),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ChatOptionsSheet(message: message, parentContext: context),
    );
  }
}

class _ChatOptionsSheet extends StatelessWidget {
  const _ChatOptionsSheet({required this.message, required this.parentContext});
  final ChatListItem message;
  final BuildContext parentContext;

  static const Color _primary = Color(0xFF2046E8);
  static const Color _danger = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        color: AppColors.card,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Handle bar ────────────────────────────────────────────────
              Container(
                margin: const EdgeInsets.only(top: 14, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 6),

              // ── Options ───────────────────────────────────────────────────
              _ChatOptionTile(
                svgPath: 'assets/icons/call.svg',
                iconColor: const Color(0xFF16A34A),
                label: 'Call with group',
                labelColor: const Color(0xFF16A34A),
                onTap: () => Get.back(),
              ),
              _ChatOptionTile(
                svgPath: 'assets/icons/pin.svg',
                label: 'Pin',
                onTap: () => Get.back(),
              ),
              _ChatOptionTile(
                svgPath: 'assets/icons/mute.svg',
                label: 'Mute',
                onTap: () => Get.back(),
              ),
              _ChatOptionTile(
                icon: Icons.group_add_outlined,
                label: 'Add members',
                onTap: () => Get.back(),
              ),
              _ChatOptionTile(
                svgPath: 'assets/icons/message.svg',
                label: 'Mark as unread',
                onTap: () => Get.back(),
              ),

              const Divider(height: 1, indent: 20, endIndent: 20),

              _ChatOptionTile(
                svgPath: 'assets/icons/leave-group.svg',
                iconColor: _danger,
                label: 'Leave group',
                labelColor: _danger,
                onTap: () => Get.back(),
              ),
              _ChatOptionTile(
                svgPath: 'assets/icons/delete.svg',
                iconColor: _danger,
                label: 'Delete',
                labelColor: _danger,
                onTap: () {
                  Get.back();
                  showDialog(
                    context: parentContext,
                    builder: (_) => AlertDialog(
                      backgroundColor: AppColors.card,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: Text('Delete conversation?',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text)),
                      content: Text(
                        'This will permanently delete your conversation with ${message.name}.',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.subtitle),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('Cancel',
                              style: TextStyle(color: AppColors.subtitle)),
                        ),
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('Delete',
                              style: TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatOptionTile extends StatelessWidget {
  const _ChatOptionTile({
    this.svgPath,
    this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  }) : assert(svgPath != null || icon != null,
            '_ChatOptionTile requires either svgPath or icon');

  final String? svgPath;
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final defaultColor = AppColors.text;
    final resolvedIconColor = iconColor ?? defaultColor;
    final resolvedLabelColor = labelColor ?? defaultColor;
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            // SVG takes priority; fall back to Material icon
            if (svgPath != null)
              SvgPicture.asset(
                svgPath!,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(resolvedIconColor, BlendMode.srcIn),
              )
            else
              Icon(icon, color: resolvedIconColor, size: 24),
            const SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: resolvedLabelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
