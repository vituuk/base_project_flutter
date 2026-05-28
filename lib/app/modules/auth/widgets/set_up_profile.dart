import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/auth/auth_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class SetUpProfilePage extends StatefulWidget {
  const SetUpProfilePage({super.key});

  @override
  State<SetUpProfilePage> createState() => _SetUpProfilePageState();
}

class _SetUpProfilePageState extends State<SetUpProfilePage> {
  late SetUpProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SetUpProfileController>();
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor       = Color(0xFFF0F3FA);
    const Color primaryBlue   = Color(0xFF2046E8);
    const Color mutedBlue     = Color(0xFF7B9FE8);
    const Color darkText      = Color(0xFF111827);
    const Color subtitleColor = Color(0xFF6B7280);
    const Color borderColor   = Color(0xFFDDE3EE);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkText,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          AuthConstants.setupProfileTitle,
          style: TextStyle(
            color: darkText,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── White Card ───────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Profile avatar icon ──────────────────────────
                        Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDE6F9),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFBFCFF5),
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.account_circle_rounded,
                              color: primaryBlue,
                              size: 40,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Heading ──────────────────────────────────────
                        Center(
                          child: Text(
                            AuthConstants.setupProfileHeading,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: darkText,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // ── Subtitle ─────────────────────────────────────
                        Center(
                          child: Text(
                            AuthConstants.setupProfileSubtitle,
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamilyNunito,
                              fontSize: 13,
                              color: subtitleColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── First Name label ──────────────────────────────
                        Text(
                          AuthConstants.setupFirstNameLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: subtitleColor,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ── First Name field ──────────────────────────────
                        _NameTextField(
                          controller: controller.firstNameController,
                          borderColor: borderColor,
                          primaryBlue: primaryBlue,
                        ),

                        const SizedBox(height: 18),

                        // ── Last Name label ───────────────────────────────
                        Text(
                          AuthConstants.setupLastNameLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: subtitleColor,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ── Last Name field ───────────────────────────────
                        _NameTextField(
                          controller: controller.lastNameController,
                          borderColor: borderColor,
                          primaryBlue: primaryBlue,
                        ),

                        const SizedBox(height: 28),

                        // ── Continue button ───────────────────────────────
                        Obx(() {
                          final filled = controller.hasInput.value;
                          final loading = controller.isLoading.value;
                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                                  loading ? null : controller.continueNext,
                              style: ElevatedButton.styleFrom(
                                // Muted blue when empty, bright blue when filled
                                backgroundColor:
                                    filled ? primaryBlue : mutedBlue,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: mutedBlue,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: loading
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
                                  : const Text(
                                      AuthConstants.continueLabel,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable name text field ──────────────────────────────────────────────────

class _NameTextField extends StatelessWidget {
  final TextEditingController controller;
  final Color borderColor;
  final Color primaryBlue;

  const _NameTextField({
    required this.controller,
    required this.borderColor,
    required this.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF111827),
        ),
        decoration: InputDecoration(
          hintText: AuthConstants.setupNameHint,
          hintStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 14),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryBlue, width: 1.8),
          ),
        ),
      ),
    );
  }
}
