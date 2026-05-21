import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/profile/edit_name_controller.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final EditNameController controller = Get.find<EditNameController>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  static Color get _primary => AppColors.primary;
  static Color get _bg => AppColors.bg;
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;

  @override
  void initState() {
    super.initState();
    final fullName = controller.currentName.trim();
    final parts = fullName.split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    
    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _saveName() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final combined = '$first $last'.trim();
    if (combined.isEmpty) {
      Get.snackbar(
        'Warning',
        'Name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF59E0B),
        colorText: Colors.white,
      );
      return;
    }
    controller.saveName(first, last);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
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
              color: _primary,
              size: 18,
            ),
          ),
        ),
        titleSpacing: 8,
        title: Text(
          'Your Name',
          style: TextStyle(
            color: _primary,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YOUR NAME',
                              style: TextStyle(
                                color: _primary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Change your name',
                              style: TextStyle(
                                color: _subtitleColor,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // First Name Field
                            Text(
                              'First name',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextField(
                              controller: _firstNameController,
                              style: TextStyle(
                                color: _darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLength: 20,
                              buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                              decoration: const InputDecoration(
                                hintText: 'Enter your first name...',
                                hintStyle: TextStyle(color: Color(0xFFCBD5E1), fontSize: 16),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                            const SizedBox(height: 16),

                            // Last Name Field
                            Text(
                              'Last name',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextField(
                              controller: _lastNameController,
                              style: TextStyle(
                                color: _darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLength: 20,
                              buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                              decoration: const InputDecoration(
                                hintText: 'Enter your last name...',
                                hintStyle: TextStyle(color: Color(0xFFCBD5E1), fontSize: 16),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Max length: 20 characters',
                          style: TextStyle(
                            color: _subtitleColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
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
          onTap: _saveName,
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
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
