import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.svgPath,
    required this.onTap,
    this.width = 28,
    this.height = 28,
  });

  final String svgPath;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(
        svgPath,
        width: width,
        height: height,
      ),
    );
  }
}
