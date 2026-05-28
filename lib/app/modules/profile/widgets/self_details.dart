import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';
import 'info_card.dart';

class SelfDetails extends StatelessWidget {
  final ProfileController controller;

  const SelfDetails({
    super.key,
    required this.controller,
  });

  static const Color _primary = Color(0xFF2046E8);
  static Color get _darkText => AppColors.text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Phone Card
        GestureDetector(
          onTapDown: (details) => _showCardMenu(context, details, true),
          child: InfoCard(
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
                          color: const Color(0xFF94A3B8),
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
          child: InfoCard(
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
                          color: const Color(0xFF94A3B8),
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
}
