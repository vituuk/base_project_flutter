import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../modules/profile/controllers/profile_controller.dart';
import '../../modules/setting/controllers/setting_controller.dart';
import 'theme_controller.dart';

class ThemeRevealWrapper extends StatefulWidget {
  final Widget child;
  const ThemeRevealWrapper({super.key, required this.child});

  @override
  State<ThemeRevealWrapper> createState() => ThemeRevealWrapperState();
}

class ThemeRevealWrapperState extends State<ThemeRevealWrapper> with SingleTickerProviderStateMixin {
  final GlobalKey _repaintKey = GlobalKey();
  ui.Image? _screenshot;
  Offset _tapPosition = Offset.zero;
  bool _animating = false;
  bool _isToDark = false;

  late AnimationController _animationController;
  // late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    // _animation = CurvedAnimation(
    //   parent: _animationController,
    //   curve: Curves.easeInOutCubic,
    // );

    // Register callback in ThemeController
    if (Get.isRegistered<ThemeController>()) {
      Get.find<ThemeController>().onThemeChangeTransition = _handleThemeTransition;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (Get.isRegistered<ThemeController>()) {
      Get.find<ThemeController>().onThemeChangeTransition = null;
    }
    super.dispose();
  }

  Future<void> _handleThemeTransition(Offset tapPosition, ThemeMode newMode) async {
    if (_animating) return;

    final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      _updateThemeMode(newMode);
      return;
    }

    try {
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final image = await boundary.toImage(pixelRatio: pixelRatio);

      setState(() {
        _screenshot = image;
        _tapPosition = tapPosition;
        _isToDark = newMode == ThemeMode.dark;
        _animating = true;
      });

      _updateThemeMode(newMode);

      _animationController.reset();
      await _animationController.forward();
    } catch (e) {
      debugPrint('Theme transition capture error: $e');
      _updateThemeMode(newMode);
    } finally {
      setState(() {
        _animating = false;
        _screenshot = null;
      });
    }
  }

  void _updateThemeMode(ThemeMode newMode) {
    if (Get.isRegistered<ThemeController>()) {
      Get.find<ThemeController>().setThemeModeDirectly(newMode);
    }
    
    final modeName = newMode == ThemeMode.dark ? 'Night Mode' : 'Day Mode';
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().themeModeName.value = modeName;
    }
    if (Get.isRegistered<SettingController>()) {
      Get.find<SettingController>().themeModeName.value = modeName;
    }
    Get.changeThemeMode(newMode);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    // Resolve target position in case it is zero (e.g. triggered programmatically).
    // In Telegram, theme toggle button is usually at the top right, so we default to there.
    final targetPosition = _tapPosition == Offset.zero
        ? Offset(size.width - 24, 48)
        : _tapPosition;

    // Calculate maxRadius once to avoid expensive calculations on every animation frame
    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];
    double maxRadius = 0.0;
    for (final corner in corners) {
      final distance = (corner - targetPosition).distance;
      if (distance > maxRadius) {
        maxRadius = distance;
      }
    }

    return RepaintBoundary(
      key: _repaintKey,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (_animating && _screenshot != null)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                // final fraction = _animation.value;
                final fraction = _animationController.value;
                final clipper = _isToDark
                    ? HoleClipper(center: targetPosition, fraction: fraction, maxRadius: maxRadius)
                    : CircleClipper(center: targetPosition, fraction: 1.0 - fraction, maxRadius: maxRadius);

                return ClipPath(
                  clipper: clipper,
                  child: RawImage(
                    image: _screenshot,
                    fit: BoxFit.fill,
                    scale: MediaQuery.of(context).devicePixelRatio,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class HoleClipper extends CustomClipper<Path> {
  final Offset center;
  final double fraction;
  final double maxRadius;

  HoleClipper({required this.center, required this.fraction, required this.maxRadius});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final radius = maxRadius * fraction;
    final holePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  bool shouldReclip(HoleClipper oldClipper) {
    return oldClipper.center != center || oldClipper.fraction != fraction || oldClipper.maxRadius != maxRadius;
  }
}

class CircleClipper extends CustomClipper<Path> {
  final Offset center;
  final double fraction;
  final double maxRadius;

  CircleClipper({required this.center, required this.fraction, required this.maxRadius});

  @override
  Path getClip(Size size) {
    final radius = maxRadius * fraction;
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(CircleClipper oldClipper) {
    return oldClipper.center != center || oldClipper.fraction != fraction || oldClipper.maxRadius != maxRadius;
  }
}
