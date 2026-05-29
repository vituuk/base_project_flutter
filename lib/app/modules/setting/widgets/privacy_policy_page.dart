import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/setting_controller.dart';

class PrivacyPolicyPage extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyPage({super.key});

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
          'Privacy Policy',
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
              // ── CARD 1: INTRODUCTION ────────────────────────────────────────
              _buildStandardCard(
                icon: Icons.shield_outlined,
                title: 'INTRODUCTION',
                description: 'Your privacy is important to us. This policy explains how we collect, use, and protect your data.',
              ),

              const SizedBox(height: 16),

              // ── CARD 2: DATA COLLECTION ────────────────────────────────────
              _buildStandardCard(
                icon: Icons.storage_rounded,
                title: 'DATA COLLECTION',
                description: 'We collect information you provide directly to us, such as your profile information and messages.',
              ),

              const SizedBox(height: 16),

              // ── CARD 3: DATA USAGE ──────────────────────────────────────────
              _buildStandardCard(
                icon: Icons.settings_outlined,
                title: 'DATA USAGE',
                description: 'We use your data to provide and improve our services, communicate with you, and ensure security.',
              ),

              const SizedBox(height: 16),

              // ── CARD 4: DATA PROTECTION ────────────────────────────────────
              _buildStandardCard(
                icon: Icons.lock_outline_rounded,
                title: 'DATA PROTECTION',
                description: 'Your messages are secured with industry-standard encryption. We prioritize your digital safety above all.',
              ),

              const SizedBox(height: 16),

              // ── CARD 5: YOUR RIGHTS (SOLID BLUE CARD) ───────────────────────
              _buildBlueCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ── STANDARD WHITE/DARK CARD BUILDER ────────────────────────────────────────
  Widget _buildStandardCard({
    required IconData icon,
    required String title,
    required String description,
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
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF2563EB),
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 14.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // ── SOLID BLUE CARD BUILDER ─────────────────────────────────────────────────
  Widget _buildBlueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'YOUR RIGHTS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'You have the right to access, update, or delete your personal information at any time. Manage your preferences in settings.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
