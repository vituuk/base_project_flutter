import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class ListMenu extends GetView<ListMenuController> {
  const ListMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final textStyle = TextStyle(
      color: textColor,
      fontFamily: AppTheme.fontFamilyNunito,
      fontFamilyFallback: AppTheme.fontFamilyFallbackKhmer,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.home),
                icon: const Icon(Icons.home),
              ),
              Text(
                'Home',
                style: textStyle,
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.detail),
              icon: const Icon(Icons.details),
            ),
            Text(
              'Detail',
              style: textStyle,
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.user),
              icon: const Icon(Icons.usb_rounded),
            ),
            Text(
              'User',
              style: textStyle,
            ),
          ],
        ),
      ],
    );
  }
}
