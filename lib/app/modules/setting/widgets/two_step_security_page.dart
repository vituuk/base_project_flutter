import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/setting_controller.dart';

class TwoStepSecurityPage extends GetView<TwoStepSecurityController> {
  const TwoStepSecurityPage({super.key});

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
          'Two-Step Verification',
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
              // ── SET PASSWORD CARD ──────────────────────────────────────────
              Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SET PASSWORD',
                      style: TextStyle(
                        color: isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Enter password label
                    Text(
                      'Enter password',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.passwordController,
                                obscureText: controller.obscurePassword.value,
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Enter your password',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF64748B),
                                size: 22,
                              ),
                              onPressed: controller.toggleObscurePassword,
                            ),
                          ],
                        )),
                    const SizedBox(height: 12),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.divider,
                    ),
                    const SizedBox(height: 16),

                    // Re-enter password label
                    Text(
                      'Re-enter password',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.reEnterPasswordController,
                                obscureText: controller.obscureReEnterPassword.value,
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Re-enter your password',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                controller.obscureReEnterPassword.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF64748B),
                                size: 22,
                              ),
                              onPressed: controller.toggleObscureReEnterPassword,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Add extra security. Enter a verification code when logging in on a new device.',
                  style: TextStyle(
                    color: isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.savePassword,
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
