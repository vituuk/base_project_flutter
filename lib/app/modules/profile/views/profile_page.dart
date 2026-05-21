import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/profiles/profile_file_item.dart';
import '../../../core/constants/profiles/profile_link_item.dart';
import '../../../core/constants/profiles/profile_media_item.dart';
import '../../../core/constants/profiles/profile_voice_item.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';



class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  // ── Palette & Theme Constants ──────────────────────────────────────────────
  static const Color _primary = Color(0xFF2046E8);
  static Color get _bg => AppColors.bg;
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;
  static const Color _onlineColor = Color(0xFF22C55E);

  // ── Datasets from constants/profiles/ ─────────────────────────────────────
  static const List<ProfileMediaItem> _mediaItems = kProfileMediaItems;
  static const List<ProfileFileItem>  _fileItems  = kProfileFileItems;
  static const List<ProfileVoiceItem> _voiceItems = kProfileVoiceItems;

  /// Builds thumbnail Widgets from [ProfileLinkThumbnail] data at runtime.
  List<ProfileLinkItem> get _linkItems => kProfileLinkItems;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelf = controller.isSelf.value;
      return Scaffold(
        backgroundColor: _bg,
        appBar: _buildAppBar(context, isSelf),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      // ── 1. Avatar & User Information ─────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildProfileHeader(isSelf),
                      ),
                      const SizedBox(height: 24),

                      // ── 2. Call/Chat Actions row ─────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: isSelf ? _buildSelfActions() : _buildOtherActions(context),
                      ),
                      const SizedBox(height: 24),

                      // ── 3. Detail Info Cards ─────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: isSelf ? _buildSelfDetails(context) : _buildOtherDetails(context),
                      ),
                      const SizedBox(height: 20),

                      // ── 4. Media/Files Tabs (Only for other user profile) ────
                      if (!isSelf) ...[
                        _buildMediaTabsSection(),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // If it's self profile, display bottom navigation bar with Profile tab active
        bottomNavigationBar: isSelf ? _buildBottomNav() : null,
      );
    });
  }

  // ── QR Code Dialog ──────────────────────────────────────────────────────────
  void _showQRCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                // QR Code with Avatar in Center
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      color: Colors.white,
                      child: Image.network(
                        'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=username:${controller.username.value}',
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _primary,
                            ),
                          );
                        },
                      ),
                    ),
                    // Centered circular avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Obx(() => _buildUserAvatar(controller.avatarUrl.value, errorIconSize: 24)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Username text in blue
                Text(
                  controller.username.value,
                  style: TextStyle(
                    color: Color(0xFF2046E8),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                // Copy button at the bottom-right
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: controller.username.value));
                        Get.back(); // close dialog
                        Get.snackbar(
                          'Success',
                          'Username copied to clipboard',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF1E293B),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 8,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5E6778),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.content_copy_rounded,
                          color: Colors.white,
                          size: 18,
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

  // ── AppBar ──────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context, bool isSelf) {
    if (isSelf) {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: _primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_2_rounded, color: _primary, size: 24),
            onPressed: () => _showQRCodeDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _primary,
            size: 18,
          ),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: _primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }

  // ── Profile Header (Avatar, Name, Status/Username) ─────────────────────────
  Widget _buildProfileHeader(bool isSelf) {
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
                child: Obx(() => _buildUserAvatar(controller.avatarUrl.value, errorIconSize: 54)),
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
        Obx(() => Text(
              controller.userName.value,
              style: TextStyle(
                color: _darkText,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            )),
        const SizedBox(height: 4),

        // Secondary Info (username or status)
        Obx(() {
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
  }

  // ── Other User Actions (Chat, Mute, Call, Video) ───────────────────────────
  Widget _buildOtherActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOtherActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          label: 'Chat',
          onTap: () => Get.back(),
        ),
        _buildOtherActionButton(
          icon: Icons.notifications_none_outlined,
          label: 'Mute',
          onTap: () {},
        ),
        _buildOtherActionButton(
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
        _buildOtherActionButton(
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

  Widget _buildOtherActionButton({
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

  // ── Self Actions (Set Photo, Edit Info) ────────────────────────────────────
  Widget _buildSelfActions() {
    return Row(
      children: [
        Expanded(
          child: _buildSelfActionButton(
            icon: Icons.camera_alt_outlined,
            label: 'Set Photo',
            onTap: () => Get.toNamed(AppRoutes.setPhoto),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSelfActionButton(
            icon: Icons.edit_outlined,
            label: 'Edit Info',
            onTap: () => Get.toNamed(AppRoutes.editInfo),
          ),
        ),
      ],
    );
  }

  Widget _buildSelfActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _primary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: _darkText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Other User Detailed Cards (Bio, Contact info, Add to contacts) ─────────
  Widget _buildOtherDetails(BuildContext context) {
    return Column(
      children: [
        // Bio Card
        _buildInfoCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BIO',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => Text(
                      controller.bio.value,
                      style: TextStyle(
                        color: _darkText,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Phone & Username Card
        _buildInfoCard(
          child: Column(
            children: [
              _buildDetailTile(
                title: 'Mobile',
                value: controller.mobile.value,
              ),
              const Divider(height: 1, thickness: 0.5, color: Color(0xFFF1F5F9), indent: 16, endIndent: 16),
              _buildDetailTile(
                title: 'Username',
                value: controller.username.value,
                trailing: GestureDetector(
                  onTap: () => _showQRCodeDialog(context),
                  child: Icon(Icons.qr_code_2_rounded, color: _primary, size: 22),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Add to Contacts Card
        _buildInfoCard(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(Icons.person_add_alt_1_outlined, color: _primary, size: 22),
                SizedBox(width: 14),
                Text(
                  'Add to contacts',
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailTile({
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: _darkText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: _subtitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          ?trailing,
        ],
      ),
    );
  }

  // ── Self Detailed Cards (Mobile, Username) ─────────────────────────────────
  Widget _buildSelfDetails(BuildContext context) {
    return Column(
      children: [
        // Phone Card
        GestureDetector(
          onTapDown: (details) => _showCardMenu(context, details, true),
          child: _buildInfoCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Icon(Icons.call_outlined, color: _primary, size: 22),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MOBILE',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                            controller.mobile.value,
                            style: TextStyle(
                              color: _darkText,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Username Card
        GestureDetector(
          onTapDown: (details) => _showCardMenu(context, details, false),
          child: _buildInfoCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Icon(Icons.alternate_email_rounded, color: _primary, size: 22),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'USERNAME',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                            controller.username.value,
                            style: TextStyle(
                              color: _darkText,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCardMenu(BuildContext context, TapDownDetails details, bool isMobile) {
    final position = details.globalPosition;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      elevation: 8,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      items: [
        PopupMenuItem(
          onTap: () {
            Clipboard.setData(ClipboardData(
              text: isMobile ? controller.mobile.value : controller.username.value,
            ));
            Get.showSnackbar(
              GetSnackBar(
                message: '${isMobile ? "Phone number" : "Username"} copied to clipboard',
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF1E293B),
                borderRadius: 8,
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          child: Row(
            children: [
              Icon(Icons.content_copy_rounded, color: _darkText, size: 20),
              const SizedBox(width: 12),
              Text(
                'Copy',
                style: TextStyle(
                  color: _darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            // delay slightly to allow menu to close before navigating
            Future.delayed(const Duration(milliseconds: 100), () {
              if (isMobile) {
                Get.toNamed(AppRoutes.changeNumber);
              } else {
                Get.toNamed(AppRoutes.editUsername);
              }
            });
          },
          child: Row(
            children: [
              Icon(Icons.sync_rounded, color: _darkText, size: 20),
              const SizedBox(width: 12),
              Text(
                isMobile ? 'Change number' : 'Change username',
                style: TextStyle(
                  color: _darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required Widget child, VoidCallback? onTap}) {
    final card = Container(
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
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }

  // ── Media/Files Tabs Section ───────────────────────────────────────────────
  Widget _buildMediaTabsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Headers with horizontal padding
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              final activeTab = controller.selectedTab.value;
              return Row(
                children: [
                  _TabItem(
                    label: 'Media',
                    isActive: activeTab == 'Media',
                    onTap: () => controller.selectedTab.value = 'Media',
                  ),
                  _TabItem(
                    label: 'Files',
                    isActive: activeTab == 'Files',
                    onTap: () => controller.selectedTab.value = 'Files',
                  ),
                  _TabItem(
                    label: 'Links',
                    isActive: activeTab == 'Links',
                    onTap: () => controller.selectedTab.value = 'Links',
                  ),
                  _TabItem(
                    label: 'Voice',
                    isActive: activeTab == 'Voice',
                    onTap: () => controller.selectedTab.value = 'Voice',
                  ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        // Tab Content
        Obx(() {
          final activeTab = controller.selectedTab.value;
          if (activeTab == 'Media') {
            return _buildMediaGrid();
          } else if (activeTab == 'Files') {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildFilesList(),
            );
          } else if (activeTab == 'Links') {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildLinksList(),
            );
          } else if (activeTab == 'Voice') {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildVoiceList(),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }

  // ── Files Tab List ──────────────────────────────────────────────────────────
  Widget _buildFilesList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _fileItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = _fileItems[index];
        return _buildInfoCard(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.fileName,
                        style: TextStyle(
                          color: _darkText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.fileSize} • ${item.fileDate}',
                        style: TextStyle(
                          color: _subtitleColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.file_download_outlined, color: Color(0xFF6B7280), size: 22),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Links Tab List ──────────────────────────────────────────────────────────
  Widget _buildLinksList() {
    final list = _linkItems;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = list[index];
        return _buildInfoCard(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildLinkThumbnail(item.thumbnail),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          color: _darkText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.url,
                        style: TextStyle(
                          color: Color(0xFF2046E8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.date,
                        style: TextStyle(
                          color: _subtitleColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.open_in_new_rounded, color: Color(0xFF6B7280), size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Converts a [ProfileLinkThumbnail] data object into a renderable Widget.
  Widget _buildLinkThumbnail(ProfileLinkThumbnail t) {
    final decoration = t.gradientColors != null
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: t.gradientColors!.map((c) => Color(c)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          )
        : BoxDecoration(
            color: Color(t.solidColor!),
            borderRadius: BorderRadius.circular(12),
          );
    return Container(
      width: 48,
      height: 48,
      decoration: decoration,
      child: Icon(
        IconData(t.iconCodePoint, fontFamily: 'MaterialIcons'),
        color: Color(t.iconColor),
        size: 22,
      ),
    );
  }

  // ── Voice Tab List ──────────────────────────────────────────────────────────
  Widget _buildVoiceList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _voiceItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = _voiceItems[index];
        return _buildInfoCard(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Play Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF2046E8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildWaveform(item.waveform),
                          const Spacer(),
                          Text(
                            item.duration,
                            style: TextStyle(
                              color: _darkText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.date,
                        style: TextStyle(
                          color: _subtitleColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.file_download_outlined, color: Color(0xFF6B7280), size: 22),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveform(List<double> heights) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: heights.asMap().entries.map((entry) {
        final index = entry.key;
        final height = entry.value;
        final isActive = index < 3;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 3,
          height: height,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2046E8) : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      }).toList(),
    );
  }

  // ── Media Content Grid matching the 3x3 layout from screenshot ─────────────
  Widget _buildMediaGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _mediaItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final item = _mediaItems[index];
        return Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFD1D5DB),
                  child: Icon(Icons.image_outlined, color: _subtitleColor),
                ),
              ),
            ),
            if (item.duration != null)
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item.duration!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ── Bottom Navigation Bar (Used only when viewing self profile) ────────────
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
                svgPath: 'lib/assets/img/menu-bar/chat.svg',
                label: 'Chats',
                isActive: false,
                onTap: () => Get.offAllNamed(AppRoutes.chat),
              ),
              _NavItem(
                svgPath: 'lib/assets/img/menu-bar/contact.svg',
                label: 'Contacts',
                isActive: false,
                onTap: () => Get.offAllNamed(AppRoutes.contact),
              ),
              _NavItem(
                svgPath: 'lib/assets/img/menu-bar/setting.svg',
                label: 'Setting',
                isActive: false,
                onTap: () => Get.offAllNamed(AppRoutes.setting),
              ),
              _NavItem(
                svgPath: 'lib/assets/img/menu-bar/profile.svg',
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

  Widget _buildUserAvatar(String url, {double? errorIconSize}) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFFDDE6F9),
          child: Icon(Icons.person_rounded, color: _primary, size: errorIconSize ?? 24),
        ),
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFFDDE6F9),
          child: Icon(Icons.person_rounded, color: _primary, size: errorIconSize ?? 24),
        ),
      );
    }
  }
}

// ── Tab Item ─────────────────────────────────────────────────────────────────
class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF2046E8) : const Color(0xFF6B7280),
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 14,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF2046E8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Nav Item ──────────────────────────────────────────────────────────
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
