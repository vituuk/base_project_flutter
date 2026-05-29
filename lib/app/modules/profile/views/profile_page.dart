import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/profile_controller.dart';
import '../widgets/other_actions.dart';
import '../widgets/other_details.dart';
import '../widgets/profile_header.dart';
import '../widgets/self_actions.dart';
import '../widgets/self_details.dart';
import '../widgets/media_tabs_section.dart';
import '../widgets/user_avatar.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  String? get tag {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['isSelf'] == false) {
      return args['username'] ?? args['name'];
    }
    return null;
  }

  // ── Palette & Theme Constants ──────────────────────────────────────────────
  static const Color _primary = Color(0xFF2046E8);
  static Color get _bg => AppColors.bg;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) => Obx(() {
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
                          child: ProfileHeader(controller: controller),
                        ),
                        const SizedBox(height: 24),

                        // ── 2. Call/Chat Actions row ─────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: isSelf ? SelfActions() : OtherActions(controller: controller),
                        ),
                        const SizedBox(height: 24),

                        // ── 3. Detail Info Cards ─────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: isSelf
                              ? SelfDetails(controller: controller)
                              : OtherDetails(
                                  controller: controller,
                                  onTapQrCode: () => _showQRCodeDialog(context),
                                ),
                        ),
                        const SizedBox(height: 20),

                        // ── 4. Media/Files Tabs (Only for other user profile) ────
                        if (!isSelf) ...[
                          MediaTabsSection(controller: controller),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
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
                          return const Center(
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
                        child: Obx(() => UserAvatar(url: controller.avatarUrl.value, errorIconSize: 24)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Username text in blue
                Text(
                  controller.username.value,
                  style: const TextStyle(
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
                        child: const Icon(
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
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: _primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2_rounded, color: _primary, size: 24),
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
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _primary,
            size: 18,
          ),
        ),
        title: const Text(
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
}
