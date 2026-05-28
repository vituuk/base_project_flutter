import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class ListMenu extends GetView<ListMenuController> {
  const ListMenu({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Text('Home'),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.detail),
                icon: const Icon(Icons.details),
              ),
              const Text('Detail'),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.user),
                icon: const Icon(Icons.usb_rounded),
              ),
              const Text('User'),
            ],
          ),
        ),
      ],
    );
  }
}
