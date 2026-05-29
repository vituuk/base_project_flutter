import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/setting_controller.dart';

class HelpCenterPage extends GetView<HelpCenterController> {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDarkMode ? Colors.white : AppColors.primary,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Text(
          'Help Center',
          style: TextStyle(
            color: isDarkMode ? Colors.white : AppColors.primary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── PAGE HEADER ────────────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Text(
                      'How can we help you?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Find answers to common questions about account security, chat features, and more.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── CATEGORIES ─────────────────────────────────────────────────
              _buildCategoryCard(
                icon: Icons.shield_outlined,
                title: 'Privacy & Security',
                subtitle: 'Learn how to keeps your private conversations secure with end-to-end encryption.',
                actionText: 'Explore security guides',
                onActionTap: () {},
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 16),

              _buildCategoryCard(
                icon: Icons.person_outline_rounded,
                title: 'Account & Profile',
                subtitle: 'Manage settings, nicknames, and data.',
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 16),

              _buildCategoryCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Chats & Media',
                subtitle: 'Sending files, voice notes, and groups.',
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 16),

              // ── TROUBLESHOOTING CARD (HORIZONTAL ROW LAYOUT) ───────────────
              _buildTroubleshootingCard(isDarkMode),

              const SizedBox(height: 32),

              // ── POPULAR ARTICLES HEADER ────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Articles',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Text(
                          'View all',
                          style: TextStyle(
                            color: Color(0xFF0284C7),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.open_in_new_rounded,
                          color: Color(0xFF0284C7),
                          size: 13,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── POPULAR ARTICLES CARD LIST ─────────────────────────────────
              _buildCardContainer([
                _buildArticleTile(
                  title: 'How do I enable two-step verification?',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildArticleTile(
                  title: 'Backup and restore your chat history',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildArticleTile(
                  title: 'Changing your phone number',
                  onTap: () {},
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // ── UI Helper Builders ─────────────────────────────────────────────────────

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onActionTap,
    required bool isDarkMode,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF082F49) : const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF0284C7),
              size: 22,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          if (actionText != null) ...[
            const SizedBox(height: 16),
            InkWell(
              onTap: onActionTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionText,
                    style: const TextStyle(
                      color: Color(0xFF0284C7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF0284C7),
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTroubleshootingCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? const Color(0xFF451A03) : const Color(0xFFFEE2E2),
            ),
            child: const Icon(
              Icons.build_outlined,
              color: Color(0xFFEF4444),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Troubleshooting',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Connection issues, notification delays, and app updates.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF94A3B8),
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.divider,
      indent: 54,
    );
  }

  Widget _buildArticleTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            const Icon(
              Icons.description_outlined,
              color: Color(0xFF475569),
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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
}
