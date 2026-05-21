import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/profile/edit_bio_controller.dart';

class EditBioPage extends StatefulWidget {
  const EditBioPage({super.key});

  @override
  State<EditBioPage> createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage> {
  final EditBioController controller = Get.find<EditBioController>();
  late TextEditingController _bioController;

  static Color get _primary => AppColors.primary;
  static Color get _bg => AppColors.bg;
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: controller.currentBio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _saveBio() {
    final value = _bioController.text.trim();
    controller.saveBio(value);
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
          'Bio',
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
                              'BIO',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Bio Field
                            TextField(
                              controller: _bioController,
                              style: TextStyle(
                                color: _darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 3,
                              maxLength: 60,
                              buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                              decoration: const InputDecoration(
                                hintText: 'Write about yourself...',
                                hintStyle: TextStyle(color: Color(0xFFCBD5E1), fontSize: 16),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Max length: 60 characters',
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
          onTap: _saveBio,
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
