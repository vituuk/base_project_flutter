import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/profile_controller.dart';
import 'info_card.dart';

class OtherDetails extends StatelessWidget {
  final ProfileController controller;
  final VoidCallback onTapQrCode;

  const OtherDetails({
    super.key,
    required this.controller,
    required this.onTapQrCode,
  });

  static const Color _primary = Color(0xFF2046E8);
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bio Card
        InfoCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BIO',
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
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
        InfoCard(
          child: Column(
            children: [
              _buildDetailTile(
                title: 'Mobile',
                value: controller.mobile.value,
              ),
              const Divider(
                height: 1,
                thickness: 0.5,
                color: Color(0xFFF1F5F9),
                indent: 16,
                endIndent: 16,
              ),
              _buildDetailTile(
                title: 'Username',
                value: controller.username.value,
                trailing: GestureDetector(
                  onTap: onTapQrCode,
                  child: const Icon(Icons.qr_code_2_rounded, color: _primary, size: 22),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Add to Contacts Card
        InfoCard(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                const Icon(Icons.person_add_alt_1_outlined, color: _primary, size: 22),
                const SizedBox(width: 14),
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
}
