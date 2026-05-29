import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/setting_controller.dart';

class AddAccountPage extends GetView<AddAccountController> {
  const AddAccountPage({super.key});

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
          'Add Account',
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
              // ── ADD ACCOUNT CARD CONTAINER ─────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                    // Header label
                    const Text(
                      'ADD ACCOUNT',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Label: Choose a country
                    const Text(
                      'Choose a country',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Country Selection dropdown row
                    InkWell(
                      onTap: () async {
                        final result = await Get.toNamed(AppRoutes.chooseCountry);
                        if (result != null && result is CountryModel) {
                          controller.selectCountry(result);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                              '${controller.selectedCountry.value.flag}  ${controller.selectedCountry.value.name}',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF94A3B8),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Label: Phone number
                    const Text(
                      'Phone number',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Flag, dial code, divider and Phone Input field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Flag & Dial Code
                          Obx(() => Text(
                            '${controller.selectedCountry.value.flag} ${controller.selectedCountry.value.code}',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          
                          // Vertical pipe separator
                          Container(
                            width: 1,
                            height: 20,
                            color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                          ),

                          // Text input field
                          Expanded(
                            child: TextField(
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: '12 555 666',
                                hintStyle: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12, right: 8),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 3,
          shape: const CircleBorder(),
          onPressed: () => controller.addAccount(),
          child: const Icon(
            Icons.check_rounded,
            size: 24,
          ),
        ),
      ),
    );
  }
}
