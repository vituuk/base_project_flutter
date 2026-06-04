import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/setting/setting_constants.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/setting_controller.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  static const Color _primary = Color(0xFF2046E8);

  @override
  Widget build(BuildContext context) {
    final SettingController controller = Get.find<SettingController>();

    return GetBuilder<ThemeController>(
      builder: (_) {
        // Dynamic Theme Colors
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final bgColor = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF2F5FC);
        final cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDarkMode ? Colors.white : const Color(0xFF111827);
        final subtitleColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
        final dividerColor = isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
        final radioBorderColor = isDarkMode ? const Color(0xFF475569) : const Color(0xFFCBD5E1);

        return Scaffold(
          backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDarkMode ? Colors.white : _primary, size: 18),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Text('Theme'.tr,
          style: TextStyle(
            color: isDarkMode ? Colors.white : _primary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ).khmer,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card container
              Container(
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header title area inside card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('THEME'.tr,
                              style: TextStyle(
                                color: isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ).khmer,
                            ),
                            const SizedBox(height: 2),
                            Text('Switch mode'.tr,
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ).khmer,
                            ),
                          ],
                        ),
                      ),

                      // Day Mode Row
                      Obx(() {
                        final isSelected = controller.themeModeName.value == SettingConstants.themeModes[0];
                        Offset? tapPosition;
                        return GestureDetector(
                          onTapDown: (details) {
                            tapPosition = details.globalPosition;
                          },
                          child: InkWell(
                            onTap: () {
                              if (Get.isRegistered<ThemeController>()) {
                                Get.find<ThemeController>().changeThemeWithAnimation(
                                  ThemeMode.light,
                                  tapPosition,
                                );
                              } else {
                                controller.setThemeMode(SettingConstants.themeModes[0]);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                              child: Row(
                                children: [
                                  Text(
                                    SettingConstants.themeModes[0],
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ).khmer,
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? _primary : radioBorderColor,
                                        width: isSelected ? 6 : 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      Divider(height: 1, thickness: 0.5, color: dividerColor),

                      // Night Mode Row
                      Obx(() {
                        final isSelected = controller.themeModeName.value == SettingConstants.themeModes[1];
                        Offset? tapPosition;
                        return GestureDetector(
                          onTapDown: (details) {
                            tapPosition = details.globalPosition;
                          },
                          child: InkWell(
                            onTap: () {
                              if (Get.isRegistered<ThemeController>()) {
                                Get.find<ThemeController>().changeThemeWithAnimation(
                                  ThemeMode.dark,
                                  tapPosition,
                                );
                              } else {
                                controller.setThemeMode(SettingConstants.themeModes[1]);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                              child: Row(
                                children: [
                                  Text(
                                    SettingConstants.themeModes[1],
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ).khmer,
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? _primary : radioBorderColor,
                                        width: isSelected ? 6 : 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
);
}
}

