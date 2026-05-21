import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile/set_photo_controller.dart';

class SetPhotoPage extends StatefulWidget {
  const SetPhotoPage({super.key});

  @override
  State<SetPhotoPage> createState() => _SetPhotoPageState();
}

class _SetPhotoPageState extends State<SetPhotoPage> {
  final SetPhotoController controller = Get.find<SetPhotoController>();

  double _rotation = 0.0; // in degrees
  bool _flipped = false;
  int _filterIndex = 0; // 0: Normal, 1: Warm, 2: B&W, 3: Cool

  ColorFilter _getColorFilter() {
    switch (_filterIndex) {
      case 1: // Warm/Vintage
        return const ColorFilter.matrix(<double>[
          1.0, 0.0, 0.0, 0.0, 20.0,
          0.0, 0.9, 0.0, 0.0, 10.0,
          0.0, 0.0, 0.8, 0.0, 0.0,
          0.0, 0.0, 0.0, 1.0, 0.0,
        ]);
      case 2: // B&W/Mono
        return const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0.0, 0.0,
          0.2126, 0.7152, 0.0722, 0.0, 0.0,
          0.2126, 0.7152, 0.0722, 0.0, 0.0,
          0.0,    0.0,    0.0,    1.0, 0.0,
        ]);
      case 3: // Cool
        return const ColorFilter.matrix(<double>[
          0.8, 0.0, 0.0, 0.0, 0.0,
          0.0, 0.9, 0.0, 0.0, 10.0,
          0.0, 0.0, 1.1, 0.0, 25.0,
          0.0, 0.0, 0.0, 1.0, 0.0,
        ]);
      default: // Normal
        return const ColorFilter.matrix(<double>[
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ]);
    }
  }

  String _getFilterName() {
    switch (_filterIndex) {
      case 1:
        return 'Warm';
      case 2:
        return 'B&W';
      case 3:
        return 'Cool';
      default:
        return 'Normal';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            
            // Image crop area with circle cutout overlay
            Expanded(
              child: Stack(
                children: [
                  // Interactive zoomable & draggable background image
                  Positioned.fill(
                    child: InteractiveViewer(
                      clipBehavior: Clip.none,
                      boundaryMargin: const EdgeInsets.all(240),
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Center(
                        child: Transform(
                          alignment: Alignment.center,
                          transform: (Matrix4.identity()
                            ..rotateZ(_rotation * 3.141592653589793 / 180.0))
                            * Matrix4.diagonal3Values(_flipped ? -1.0 : 1.0, 1.0, 1.0),
                          child: ColorFiltered(
                            colorFilter: _getColorFilter(),
                            child: Image.asset(
                              'lib/assets/img/crop_profile_girl.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Semi-transparent overlay with a circular cutout
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.5),
                      BlendMode.srcOut,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            backgroundBlendMode: BlendMode.dstOut,
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 320,
                            height: 320,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom toolbar
            Container(
              color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flip Horizontally
                  IconButton(
                    icon: const Icon(Icons.crop_rotate_rounded, color: Colors.white, size: 24),
                    onPressed: () {
                      setState(() {
                        _flipped = !_flipped;
                      });
                      Get.showSnackbar(
                        GetSnackBar(
                          message: 'Flipped Horizontally',
                          duration: const Duration(milliseconds: 800),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF2046E8).withValues(alpha: 0.9),
                          borderRadius: 8,
                          margin: const EdgeInsets.only(bottom: 90, left: 24, right: 24),
                        ),
                      );
                    },
                  ),
                  // Rotate 90 deg Right
                  IconButton(
                    icon: const Icon(Icons.rotate_right_rounded, color: Colors.white, size: 24),
                    onPressed: () {
                      setState(() {
                        _rotation = (_rotation + 90) % 360;
                      });
                    },
                  ),
                  // Tune Filters
                  IconButton(
                    icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 24),
                    onPressed: () {
                      setState(() {
                        _filterIndex = (_filterIndex + 1) % 4;
                      });
                      Get.showSnackbar(
                        GetSnackBar(
                          message: 'Filter: ${_getFilterName()}',
                          duration: const Duration(milliseconds: 800),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF2046E8).withValues(alpha: 0.9),
                          borderRadius: 8,
                          margin: const EdgeInsets.only(bottom: 90, left: 24, right: 24),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      // Set the photo and return
                      controller.saveAvatar('lib/assets/img/crop_profile_girl.png');
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Profile photo updated successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF1E293B),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 8,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2046E8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
