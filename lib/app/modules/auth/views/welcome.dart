import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/auth/auth_constants.dart';
import '../controllers/auth_controller.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: AuthConstants.welcomeAnimDurationMs),
    );

    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WelcomeController>();
    const Color bgColor    = Color(0xFFF4F6FA);
    const Color primaryBlue = Color(0xFF2046E8);
    const Color darkText   = Color(0xFF111827);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                // Ensures Column still fills the screen on tall devices
                // so Spacers work — but allows scroll on short/landscape screens
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 5),

                        // ── "Successful login" label ─────────────────────────
                        FadeTransition(
                          opacity: _fadeIn,
                          child: SlideTransition(
                            position: _slideUp,
                            child: const Text(
                              AuthConstants.welcomeLoginLabel,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: darkText,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ── "Welcome Back" heading ───────────────────────────
                        FadeTransition(
                          opacity: _fadeIn,
                          child: SlideTransition(
                            position: _slideUp,
                            child: const Text(
                              AuthConstants.welcomeHeading,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                color: darkText,
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // ── User name in blue ────────────────────────────────
                        FadeTransition(
                          opacity: _fadeIn,
                          child: SlideTransition(
                            position: _slideUp,
                            child: Obx(() {
                              final name = controller.userName.value;
                              return Text(
                                name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                  color: primaryBlue,
                                  height: 1.15,
                                  letterSpacing: -0.5,
                                ),
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ── Description ──────────────────────────────────────
                        FadeTransition(
                          opacity: _fadeIn,
                          child: const Text(
                            AuthConstants.welcomeDescription,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF434655),
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                            ),
                          ),
                        ),

                        const Spacer(flex: 4),

                        // ── Continue Button ──────────────────────────────────
                        FadeTransition(
                          opacity: _fadeIn,
                          child: SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () => controller.goToHome(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: primaryBlue.withOpacity(0.35),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                AuthConstants.continueLabel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
