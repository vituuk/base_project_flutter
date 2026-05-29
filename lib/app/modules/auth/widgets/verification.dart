import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/auth/auth_constants.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/auth_controller.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late VerificationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VerificationController>();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = AppColors.bg;
    final Color primaryBlue = AppColors.primary;
    final Color darkText = AppColors.text;
    final Color subtitleColor = AppColors.subtitle;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: darkText, size: 20),
        ),
        title: Text(
          AuthConstants.verificationTitle,
          style: TextStyle(
            color: darkText,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // ── White Card ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
              child: Column(
                children: [
                  // ── Shield icon ────────────────────────────────────────
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFDDE6F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shield_rounded,
                      color: isDarkMode ? Colors.white : primaryBlue,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── "Verify Code" heading ─────────────────────────────
                  Text(
                    AuthConstants.verificationHeading,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Subtitle with phone number ────────────────────────
                  Builder(builder: (_) {
                    final phone = controller.phoneNumber.isNotEmpty
                        ? controller.phoneNumber
                        : AuthConstants.fallbackPhoneNumber;
                    return Text(
                      'Enter the ${AuthConstants.otpLength}-digit code sent to $phone',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: subtitleColor,
                        height: 1.5,
                      ),
                    );
                  }),

                  const SizedBox(height: 28),

                  // ── OTP boxes ─────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      AuthConstants.otpLength,
                      (i) => _OtpBox(
                        controller: controller.otpControllers[i],
                        focusNode: controller.focusNodes[i],
                        primaryBlue: primaryBlue,
                        onChanged: (v) => controller.onDigitChanged(i, v),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Countdown timer ───────────────────────────────────
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(() => Text(
                          controller.formattedTime,
                          style: TextStyle(
                            fontSize: 13,
                            color: subtitleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ),

                  const SizedBox(height: 24),

                  // ── Verify & Continue button ──────────────────────────
                  Obx(() => SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.verify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: isDarkMode ? Colors.black : Colors.white,
                            disabledBackgroundColor:
                                primaryBlue.withValues(alpha: 0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            isDarkMode ? Colors.black : Colors.white),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AuthConstants.verificationButton,
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.black : Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(Icons.arrow_forward_rounded,
                                        size: 18, color: isDarkMode ? Colors.black : Colors.white),
                                  ],
                                ),
                        ),
                      )),

                  const SizedBox(height: 20),

                  // ── Resend section ────────────────────────────────────
                  Text(
                    AuthConstants.verificationResendPrompt,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Obx(() => GestureDetector(
                        onTap: controller.canResend.value
                            ? controller.resendCode
                            : null,
                        child: Text(
                          AuthConstants.verificationResendButton,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: controller.canResend.value
                                ? (isDarkMode ? Colors.white : primaryBlue)
                                : Colors.grey.shade400,
                          ),
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 28),

            if (!controller.isChangeNumber) ...[
              // ── Back to Sign in ──────────────────────────────────────────
              RichText(
                text: TextSpan(
                  text: AuthConstants.verificationBackTo,
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          AuthConstants.verificationSignIn,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode ? Colors.white : primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Privacy Policy · Terms of Service ───────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    AuthConstants.privacyPolicy,
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    AuthConstants.termsOfService,
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Single OTP digit box ──────────────────────────────────────────────────────

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color primaryBlue;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.primaryBlue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 46,
      height: 54,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFDDE3EE),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryBlue, width: 1.8),
          ),
          filled: true,
          fillColor: AppColors.input,
        ),
      ),
    );
  }
}
