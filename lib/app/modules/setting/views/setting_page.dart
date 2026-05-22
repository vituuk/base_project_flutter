import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/setting/setting_constants.dart';
import '../../../routes/app_routes.dart';
import '../controllers/setting_controller.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final SettingController controller = Get.find<SettingController>();

  // Palette & Theme Constants
  static const Color _primary = Color(0xFF2046E8);
  static const Color _onlineColor = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    // Dynamic Theme Colors
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF2F5FC);
    final cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final dividerColor = isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final listIconColor = isDarkMode ? Colors.white70 : const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDarkMode ? Colors.white : _primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: isDarkMode ? Colors.white : _primary, size: 24),
            onPressed: () {
              Get.showSnackbar(
                GetSnackBar(
                  message: 'Settings options tapped',
                  duration: const Duration(seconds: 1),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: isDarkMode ? const Color(0xFF334155) : const Color(0xFF1E293B),
                  borderRadius: 8,
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── 1. User Header Section ──
              _buildUserHeader(textColor, subtitleColor),
              const SizedBox(height: 24),

              // ── 2. Account Section Card ──
              _buildSectionHeader(SettingConstants.sectionAccount),
              _buildCardContainer(cardColor, [
                _buildListTile(
                  icon: Icons.lock_outline_rounded,
                  title: SettingConstants.itemPrivacy,
                  textColor: textColor,
                  iconColor: listIconColor,
                  onTap: () => Get.toNamed(AppRoutes.privacy),
                ),
                Divider(height: 1, thickness: 0.5, color: dividerColor, indent: 56, endIndent: 16),
                _buildListTile(
                  icon: Icons.security_rounded,
                  title: SettingConstants.itemSecurity,
                  textColor: textColor,
                  iconColor: listIconColor,
                  onTap: () => Get.toNamed(AppRoutes.security),
                ),
                Divider(height: 1, thickness: 0.5, color: dividerColor, indent: 56, endIndent: 16),
                _buildListTile(
                  icon: Icons.smartphone_rounded,
                  title: SettingConstants.itemChangeNumber,
                  textColor: textColor,
                  iconColor: listIconColor,
                  onTap: () => Get.toNamed(AppRoutes.changeNumber),
                ),
              ]),
              const SizedBox(height: 20),

              // ── 3. Chats Section Card ──
              _buildSectionHeader(SettingConstants.sectionChats),
              _buildCardContainer(cardColor, [
                Obx(() => _buildListTile(
                      icon: Icons.palette_outlined,
                      title: SettingConstants.itemTheme,
                      subtitle: controller.themeModeName.value,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      iconColor: listIconColor,
                      onTap: () => Get.toNamed(AppRoutes.theme),
                    )),
              ]),
              const SizedBox(height: 20),

              // ── 4. Notifications Section Card ──
              _buildSectionHeader(SettingConstants.sectionNotifications),
              _buildCardContainer(cardColor, [
                _buildListTile(
                  icon: Icons.notifications_none_rounded,
                  title: SettingConstants.itemNotifications,
                  textColor: textColor,
                  iconColor: listIconColor,
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 20),

              // ── 5. Storage Section Card ──
              _buildSectionHeader(SettingConstants.sectionStorage),
              _buildCardContainer(cardColor, [
                _buildListTile(
                  icon: Icons.data_usage_rounded,
                  title: SettingConstants.itemStorage,
                  textColor: textColor,
                  iconColor: listIconColor,
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 20),

              // ── 6. Information Section Card ──
              _buildSectionHeader(SettingConstants.sectionInformation),
              _buildCardContainer(cardColor, [
                _buildListTile(
                  icon: Icons.help_outline_rounded,
                  title: SettingConstants.itemHelpCenter,
                  textColor: textColor,
                  iconColor: listIconColor,
                  onTap: () {},
                ),
                Divider(height: 1, thickness: 0.5, color: dividerColor, indent: 56, endIndent: 16),
                _buildListTile(
                  icon: Icons.mail_outline_rounded,
                  title: SettingConstants.itemContactUs,
                  textColor: textColor,
                  iconColor: listIconColor,
                  onTap: () {},
                ),
                Divider(height: 1, thickness: 0.5, color: dividerColor, indent: 56, endIndent: 16),
                _buildListTile(
                  icon: Icons.description_outlined,
                  title: SettingConstants.itemPrivacyPolicy,
                  textColor: textColor,
                  iconColor: listIconColor,
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 20),

              // ── 7. Extra Actions Card (Add Account, Logout) ──
              _buildCardContainer(cardColor, [
                _buildListTile(
                  icon: Icons.person_add_alt_1_outlined,
                  title: SettingConstants.itemAddAccount,
                  textColor: _primary,
                  iconColor: _primary,
                  onTap: () {},
                ),
                Divider(height: 1, thickness: 0.5, color: dividerColor, indent: 56, endIndent: 16),
                _buildListTile(
                  icon: Icons.logout_rounded,
                  title: SettingConstants.itemLogout,
                  textColor: const Color(0xFFEF4444),
                  iconColor: const Color(0xFFEF4444),
                  onTap: () => _showLogoutDialog(context, isDarkMode, textColor, subtitleColor),
                ),
              ]),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(cardColor),
    );
  }

  Widget _buildUserHeader(Color textColor, Color subtitleColor) {
    return Column(
      children: [
        // Avatar stack
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
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
                child: Obx(() => _buildUserAvatar(controller.avatarUrl.value)),
              ),
            ),
            // Online Indicator Dot
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: _onlineColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // User Display Name
        Obx(() => Text(
              controller.userName.value,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            )),
        const SizedBox(height: 2),

        // @Username
        Obx(() => Text(
              controller.username.value,
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )),
        const SizedBox(height: 6),

        // Edit Profile Button
        TextButton(
          onPressed: () => Get.toNamed(AppRoutes.editInfo),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            SettingConstants.itemEditProfile,
            style: TextStyle(
              color: _primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFFDDE6F9),
          child: const Icon(Icons.person_rounded, color: _primary, size: 40),
        ),
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFFDDE6F9),
          child: const Icon(Icons.person_rounded, color: _primary, size: 40),
        ),
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildCardContainer(Color cardColor, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
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
        children: children,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color textColor,
    Color? subtitleColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subtitleColor ?? const Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDarkMode, Color textColor, Color subtitleColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            SettingConstants.logoutDialogTitle,
            style: TextStyle(
              color: textColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            SettingConstants.logoutDialogBody,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(SettingConstants.logoutDialogCancel, style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                Get.offAllNamed(AppRoutes.login);
              },
              child: const Text(
                SettingConstants.logoutDialogConfirm,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNav(Color cardColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
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
              _BottomNavItem(
                svgPath: 'lib/assets/img/menu-bar/chat.svg',
                label: 'Chats',
                isActive: false,
                onTap: () => Get.offAllNamed(AppRoutes.chat),
              ),
              _BottomNavItem(
                svgPath: 'lib/assets/img/menu-bar/contact.svg',
                label: 'Contacts',
                isActive: false,
                onTap: () => Get.offAllNamed(AppRoutes.contact),
              ),
              _BottomNavItem(
                svgPath: 'lib/assets/img/menu-bar/setting.svg',
                label: 'Setting',
                isActive: true,
                onTap: () {},
              ),
              _BottomNavItem(
                svgPath: 'lib/assets/img/menu-bar/profile.svg',
                label: 'Profile',
                isActive: false,
                onTap: () => Get.offAllNamed(AppRoutes.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
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
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
