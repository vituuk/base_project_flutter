import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/auth/auth_constants.dart';
import '../controllers/verification_controller.dart';

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
    const Color bgColor = Color(0xFFF2F5FC);
    const Color primaryBlue = Color(0xFF2046E8);
    const Color darkText = Color(0xFF111827);
    const Color subtitleColor = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: darkText, size: 20),
        ),
        title: const Text(
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
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
                      color: const Color(0xFFDDE6F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: primaryBlue,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── "Verify Code" heading ─────────────────────────────
                  const Text(
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
                      style: const TextStyle(
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
                          style: const TextStyle(
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
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                primaryBlue.withOpacity(0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      AuthConstants.verificationButton,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward,
                                        size: 18, color: Colors.white),
                                  ],
                                ),
                        ),
                      )),

                  const SizedBox(height: 20),

                  // ── Resend section ────────────────────────────────────
                  const Text(
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
                                ? primaryBlue
                                : Colors.grey.shade400,
                          ),
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Back to Sign in ──────────────────────────────────────────
            RichText(
              text: TextSpan(
                text: AuthConstants.verificationBackTo,
                style: const TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text(
                        AuthConstants.verificationSignIn,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Privacy Policy · Terms of Service ───────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text(
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
                  child: const Text(
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
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFFDDE3EE), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryBlue, width: 1.8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
