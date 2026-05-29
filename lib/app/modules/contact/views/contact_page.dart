import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/contact_controller.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  // ── Colour palette ─────────────────────────────────────────────────────────
  static Color get _bg => AppColors.bg;
  static Color get _primary => AppColors.primary;
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;
  static Color get _searchBg => AppColors.input;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) => Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildSearchBar(),
              _buildSortedLabel(),
              Expanded(child: _buildContactList()),
            ],
          ),
        ),
        floatingActionButton: _buildFab(),
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Contacts',
              style: TextStyle(
                color: _primary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ),
          // ≡A  sort-by-name icon / sort-by-time icon
          GestureDetector(
            onTap: () => controller.toggleSortType(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Obx(() => SvgPicture.asset(
                      controller.sortByLastSeen.value
                          ? 'assets/icons/contact/list-last-time.svg'
                          : 'assets/icons/contact/list-name.svg',
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(AppColors.text, BlendMode.srcIn),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────────
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
              color: Colors.black.withValues(alpha: 0.06),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 13),
          ),
        ),
      ),
    );
  }

  // ── "Sorted by name" / "Sorted by last seen time" label ──────────────────────
  Widget _buildSortedLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 2),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Obx(() => Text(
              controller.sortByLastSeen.value
                  ? 'Sorted by last seen time'
                  : 'Sorted by name',
              style: TextStyle(
                color: _primary.withValues(alpha: 0.85),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            )),
      ),
    );
  }

  // ── Contact list ───────────────────────────────────────────────────────────
  Widget _buildContactList() {
    return Obx(() {
      if (controller.sortByLastSeen.value) {
        final contacts = controller.filteredContacts;
        if (contacts.isEmpty) {
          return Center(
            child: Text(
              'No contacts found',
              style: TextStyle(color: _subtitleColor, fontSize: 14),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _ContactCard(contact: contacts[index]);
          },
        );
      } else {
        final groups = controller.groupKeys;
        if (groups.isEmpty) {
          return Center(
            child: Text(
              'No contacts found',
              style: TextStyle(color: _subtitleColor, fontSize: 14),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final key = groups[index];
            final contacts = controller.contactsForGroup(key);
            return _ContactGroup(groupKey: key, contacts: contacts);
          },
        );
      }
    });
  }

  // ── FAB ────────────────────────────────────────────────────────────────────
  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () => _showAddContactBottomSheet(),
      backgroundColor: _primary,
      shape: const CircleBorder(),
      child: SvgPicture.asset(
        'assets/icons/add-contact.svg',
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          AppColors.isDarkMode ? const Color(0xFF0F172A) : Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  void _showAddContactBottomSheet() {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final bool isDark = AppColors.isDarkMode;

    final Color sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF111827);
    final Color labelColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final Color fieldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF2F5FC);
    final Color borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: Get.mediaQuery.viewInsets.bottom + 24, // Respect keyboard insets
        ),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // First Name Field
              Text(
                'First name',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: fieldBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: TextField(
                  controller: firstNameController,
                  style: TextStyle(color: textColor, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Tina',
                    hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.5), fontSize: 15),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Last Name Field
              Text(
                'Last name',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: fieldBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: TextField(
                  controller: lastNameController,
                  style: TextStyle(color: textColor, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Lida',
                    hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.5), fontSize: 15),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              Text(
                'Phone number',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: fieldBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  children: [
                    // Flag and Code
                    Row(
                      children: [
                        const Text(
                          '🇰🇭',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '+855',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '|',
                          style: TextStyle(
                            color: labelColor.withValues(alpha: 0.4),
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: textColor, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: '12 555 666',
                          hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.5), fontSize: 15),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Create Contact Button
              ElevatedButton(
                onPressed: () {
                  final first = firstNameController.text.trim();
                  final last = lastNameController.text.trim();
                  final phone = phoneController.text.trim();
                  
                  if (first.isEmpty && last.isEmpty) {
                    Get.snackbar(
                      'Input Error',
                      'Please enter a name.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                      colorText: Colors.white,
                    );
                    return;
                  }

                  controller.addContact(
                    firstName: first,
                    lastName: last,
                    phone: '+855 $phone',
                  );
                  Get.back(); // close bottom sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2046E8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Create Contact',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ── Bottom navigation ──────────────────────────────────────────────────────
  Widget _buildBottomNav() {
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
              _NavItem(
                svgPath: 'assets/icons/menu-bar/chat.svg',
                label: 'Chats',
                isActive: false,
                onTap: () => Get.back(),
              ),
              _NavItem(
                svgPath: 'assets/icons/menu-bar/contact.svg',
                label: 'Contacts',
                isActive: true,
                onTap: () {},
              ),
              _NavItem(
                svgPath: 'assets/icons/menu-bar/setting.svg',
                label: 'Setting',
                isActive: false,
                onTap: () => Get.offAllNamed(AppRoutes.setting),
              ),
              _NavItem(
                svgPath: 'assets/icons/menu-bar/profile.svg',
                label: 'Profile',
                isActive: false,
                onTap: () => Get.toNamed(
                  AppRoutes.profile,
                  arguments: {'isSelf': true},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Contact Group (alphabet section) ──────────────────────────────────────────
class _ContactGroup extends StatelessWidget {
  const _ContactGroup({
    required this.groupKey,
    required this.contacts,
  });

  final String groupKey;
  final List<ContactItem> contacts;

  static const Color _primary = Color(0xFF2046E8);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4),
          child: Text(
            groupKey,
            style: TextStyle(
              color: _primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Column(
          children: contacts.map((c) => _ContactCard(contact: c)).toList(),
        ),
      ],
    );
  }
}

// ── Contact Card ──────────────────────────────────────────────────────────────
class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact});

  final ContactItem contact;

  static const Color _primary = Color(0xFF2046E8);
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;
  static const Color _onlineDot = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRoutes.profile,
                  arguments: {
                    'isSelf': false,
                    'name': contact.name,
                    'avatarUrl': contact.avatarUrl ?? '',
                    'isOnline': contact.isOnline,
                    'username': '@${contact.name.toLowerCase().replaceAll(' ', '_')}',
                    'mobile': contact.name == 'Alex Rivera' ? '+855 12777333' : '+855 12888999',
                    'bio': 'Hi',
                    'status': contact.isOnline ? 'online' : 'last seen recently',
                  },
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  // ── Avatar ─────────────────────────────────────────────────────────
                  Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.divider, width: 1.0),
                        ),
                        child: ClipOval(child: _buildAvatar()),
                      ),
                      if (contact.isOnline)
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _onlineDot,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.card, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // ── Name + Status ───────────────────────────────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _darkText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contact.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: _subtitleColor,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ── Action buttons — SVGs from /img/contact/ ────────────────────────
          _SvgActionButton(
            svgPath: 'assets/icons/contact/chat.svg',
            onTap: () => Get.toNamed(
              AppRoutes.chatDetail,
              arguments: {
                'name': contact.name,
                'avatarUrl': contact.avatarUrl ?? '',
                'isOnline': contact.isOnline,
              },
            ),
          ),
          const SizedBox(width: 8),
          _SvgActionButton(
            svgPath: 'assets/icons/contact/call.svg',
            onTap: () => Get.toNamed(
              AppRoutes.userCall,
              arguments: {
                'name': contact.name,
                'avatarUrl': contact.avatarUrl ?? '',
                'isVideo': false,
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (contact.avatarUrl != null) {
      return Image.network(
        contact.avatarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _initialsAvatar(),
      );
    }
    return _initialsAvatar();
  }

  Widget _initialsAvatar() {
    final bool isDark = AppColors.isDarkMode;
    return Container(
      color: isDark ? const Color(0xFF334155) : const Color(0xFFDDE6F9),
      alignment: Alignment.center,
      child: Text(
        contact.initials,
        style: TextStyle(
          color: isDark ? Colors.white : _primary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── SVG Action Button (chat / call) ────────────────────────────────────────────
class _SvgActionButton extends StatelessWidget {
  const _SvgActionButton({
    required this.svgPath,
    required this.onTap,
  });

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
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.divider, width: 1.5),
          color: AppColors.card,
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
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
