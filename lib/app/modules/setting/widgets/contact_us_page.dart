import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/setting_controller.dart';

class ContactUsPage extends GetView<ContactUsController> {
  const ContactUsPage({super.key});

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
          'Contact Us',
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
            children: [
              // ── CARD 1: LIVE CHAT ──────────────────────────────────────────
              _buildLiveChatCard(context, isDarkMode),

              const SizedBox(height: 20),

              // ── CARD 2: EMAIL SUPPORT ──────────────────────────────────────
              _buildSupportCard(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.mail_outline_rounded,
                title: 'Email Support',
                description: 'Response time: < 24h. Perfect for detailed inquiries.',
                buttonText: 'Send Email',
                onButtonTap: () => controller.sendEmail(),
              ),

              const SizedBox(height: 20),

              // ── CARD 3: SEND FEEDBACK ──────────────────────────────────────
              _buildSupportCard(
                context: context,
                isDarkMode: isDarkMode,
                icon: Icons.rate_review_outlined,
                title: 'Send Feedback',
                description: 'Help us improve by sharing your thoughts and suggestions.',
                buttonText: 'Give Feedback',
                onButtonTap: () => controller.giveFeedback(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── LIVE CHAT CARD BUILDER ──────────────────────────────────────────────────
  Widget _buildLiveChatCard(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Chat icon box
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
              ),
              // Online status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Online',
                      style: TextStyle(
                        color: isDarkMode ? const Color(0xFF4ADE80) : const Color(0xFF15803D),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Live Chat',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Chat with our experts instantly for immediate assistance.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          // Start Chat Button (Solid Blue)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => controller.startLiveChat(),
              child: const Text(
                'Start Chat',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── STANDARD SUPPORT CARD BUILDER (EMAIL / FEEDBACK) ────────────────────────
  Widget _buildSupportCard({
    required BuildContext context,
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onButtonTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2563EB),
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          // Outline button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2563EB),
                side: const BorderSide(color: Color(0xFF2563EB), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onButtonTap,
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
