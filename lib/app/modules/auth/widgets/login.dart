import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/auth/auth_constants.dart';
import '../../../core/constants/auth/country_item.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LoginController>();
  }

  // ── Show country picker bottom sheet ──────────────────────────────────────
  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountryPickerSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue  = Color(0xFF5B7CDD);
    const Color darkText     = Color(0xFF111827);
    const Color subtitleColor = Color(0xFF6B7280);
    const Color borderColor  = Color(0xFFDDE3EE);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        // ── Gradient background ────────────────────────────────────
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEF3FC),
              Color(0xFFDDE6F5),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.08),

                        // ── Top subtitle ──────────────────────────────────
                        Text(
                          AuthConstants.loginSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: constraints.maxHeight * 0.05),

                        // ── Card ──────────────────────────────────────────
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 24,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding:
                                const EdgeInsets.fromLTRB(24, 36, 24, 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Card heading ─────────────────────────
                                Center(
                                  child: Text(
                                    AuthConstants.loginHeading,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: darkText,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Center(
                                  child: Text(
                                    AuthConstants.loginCardSubtitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: subtitleColor,
                                      height: 1.55,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // ── "Phone Number" label ─────────────────
                                Text(
                                  AuthConstants.loginPhoneLabel,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: darkText,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // ── Phone input row ──────────────────────
                                Row(
                                  children: [
                                    Obx(() => _CountryPickerButton(
                                          flag: controller.flagEmoji.value,
                                          code: controller.dialCode.value,
                                          borderColor: borderColor,
                                          onTap: _showCountryPicker, // ← wired
                                        )),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _PhoneTextField(
                                        controller:
                                            controller.phoneController,
                                        borderColor: borderColor,
                                        primaryBlue: primaryBlue,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 40),

                                // ── Verify Code button ───────────────────
                                Obx(() => SizedBox(
                                      width: double.infinity,
                                      height: 54,
                                      child: ElevatedButton(
                                        onPressed:
                                            controller.isLoading.value
                                                ? null
                                                : controller.verifyCode,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryBlue,
                                          foregroundColor: Colors.white,
                                          disabledBackgroundColor:
                                              primaryBlue.withOpacity(0.6),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: controller.isLoading.value
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                          Colors.white),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    AuthConstants
                                                        .loginVerifyButton,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Icon(
                                                      Icons.arrow_forward,
                                                      size: 18,
                                                      color: Colors.white),
                                                ],
                                              ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(),

                        // ── Bottom links ──────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 24),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  AuthConstants.loginHelpCenter,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2046E8),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  AuthConstants.privacyPolicy,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2046E8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Country Picker Bottom Sheet ───────────────────────────────────────────────

class _CountryPickerSheet extends StatefulWidget {
  final LoginController controller;
  const _CountryPickerSheet({required this.controller});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  static const Color _primary   = Color(0xFF2046E8);
  static const Color _darkText  = Color(0xFF111827);
  static const Color _subtitle  = Color(0xFF6B7280);
  static const Color _border    = Color(0xFFDDE3EE);
  static const Color _bgSheet   = Color(0xFFF8FAFF);

  String _query = '';
  List<CountryItem> _filtered = kCountries;

  void _onSearch(String q) {
    setState(() {
      _query = q.toLowerCase();
      _filtered = q.isEmpty
          ? kCountries
          : kCountries
              .where((c) =>
                  c.name.toLowerCase().contains(_query) ||
                  c.dialCode.contains(_query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: _bgSheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // ── Handle bar ─────────────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Title ──────────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  'Select Country',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _darkText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Search field ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              autofocus: false,
              onChanged: _onSearch,
              style: const TextStyle(fontSize: 14, color: _darkText),
              decoration: InputDecoration(
                hintText: 'Search country or code…',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFB0B8CC),
                ),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: Color(0xFF94A3B8), size: 20),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _border, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primary, width: 1.6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          const Divider(height: 1, thickness: 0.5, color: _border),

          // ── Country list ───────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No countries found',
                      style: TextStyle(color: _subtitle, fontSize: 14),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.only(
                      top: 6,
                      bottom: bottomPadding + 24,
                    ),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: _border,
                      indent: 56,
                    ),
                    itemBuilder: (_, i) {
                      final country = _filtered[i];
                      final isSelected =
                          widget.controller.dialCode.value ==
                              country.dialCode;
                      return InkWell(
                        onTap: () =>
                            widget.controller.selectCountry(country),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              // Flag
                              Text(
                                country.flag,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 14),
                              // Name
                              Expanded(
                                child: Text(
                                  country.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? _primary
                                        : _darkText,
                                  ),
                                ),
                              ),
                              // Dial code
                              Text(
                                country.dialCode,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? _primary
                                      : _subtitle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Checkmark
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded,
                                    color: _primary, size: 18)
                              else
                                const SizedBox(width: 18),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _CountryPickerButton extends StatelessWidget {
  final String flag;
  final String code;
  final Color borderColor;
  final VoidCallback onTap;

  const _CountryPickerButton({
    required this.flag,
    required this.code,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text(
              code,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 18, color: Color(0xFF6B7280)),
          ],
        ),
      ),
    );
  }
}

class _PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final Color borderColor;
  final Color primaryBlue;

  const _PhoneTextField({
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
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF111827),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: AuthConstants.loginPhoneHint,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xFFB0B8CC),
            fontWeight: FontWeight.w400,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
