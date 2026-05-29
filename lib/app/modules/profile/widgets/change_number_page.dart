import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class _Country {
  final String name;
  final String code;
  final String flag;

  const _Country({required this.name, required this.code, required this.flag});
}

class ChangeNumberPage extends StatefulWidget {
  const ChangeNumberPage({super.key});

  @override
  State<ChangeNumberPage> createState() => _ChangeNumberPageState();
}

class _ChangeNumberPageState extends State<ChangeNumberPage> {
  final ChangeNumberController controller = Get.find<ChangeNumberController>();
  late TextEditingController _phoneController;

  static Color get _primary => AppColors.primary;
  static Color get _bg => AppColors.bg;
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;

  final List<_Country> _countries = const [
    _Country(name: 'Cambodia', code: '+855', flag: '🇰🇭'),
    _Country(name: 'United States', code: '+1', flag: '🇺🇸'),
    _Country(name: 'Vietnam', code: '+84', flag: '🇻🇳'),
    _Country(name: 'Singapore', code: '+65', flag: '🇸🇬'),
    _Country(name: 'Laos', code: '+856', flag: '🇱🇦'),
  ];

  late _Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries.first; // Default to Cambodia

    // Try to parse country code from existing mobile
    final currentPhone = controller.currentPhone.trim();
    for (final c in _countries) {
      if (currentPhone.startsWith(c.code)) {
        _selectedCountry = c;
        final numOnly = currentPhone.substring(c.code.length).trim();
        _phoneController = TextEditingController(text: numOnly);
        return;
      }
    }
    _phoneController = TextEditingController(text: currentPhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showCountrySelector() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  'Select Country',
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    final country = _countries[index];
                    return ListTile(
                      leading: Text(
                        country.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        country.name,
                        style: TextStyle(
                          color: _darkText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        country.code,
                        style: TextStyle(
                          color: _primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCountry = country;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _savePhoneNumber() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar(
        'Warning',
        'Please enter a mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF59E0B),
        colorText: Colors.white,
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    final fullNumber = '${_selectedCountry.code} $phone'.trim();
    Get.toNamed(
      AppRoutes.verification,
      arguments: {
        'phoneNumber': fullNumber,
        'isChangeNumber': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDarkMode ? Colors.white : _primary,
              size: 18,
            ),
          ),
        ),
        titleSpacing: 8,
        title: Text(
          'Change number',
          style: TextStyle(
            color: isDarkMode ? Colors.white : _primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'New Number',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Your new number will receive a confirmation code via call or SMS.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _subtitleColor,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 28),
                        
                        // Row containing Country Selector and Phone Input
                        Row(
                          children: [
                            // Country Selector
                            GestureDetector(
                              onTap: _showCountrySelector,
                              child: Container(
                                height: 48,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedCountry.flag,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _selectedCountry.code,
                                      style: TextStyle(
                                        color: _darkText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: _subtitleColor,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                            // Mobile Number Field
                            Expanded(
                              child: Container(
                                height: 48,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      color: _darkText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Mobile number',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 8),
        child: GestureDetector(
          onTap: _savePhoneNumber,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
