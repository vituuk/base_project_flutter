import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class MenuBarController extends GetxController {
  final activeRoute = ''.obs;

  @override
  void onInit() {
    super.onInit();
    activeRoute.value = Get.currentRoute;
  }

  void navigateTo(String route) {
    activeRoute.value = route;
    Get.toNamed(route);
  }

  final menuItems = <Map<String, dynamic>>[
    {'label': 'Home', 'route': AppRoutes.home},
    {'label': 'Detail', 'route': AppRoutes.detail},
    {'label': 'User', 'route': AppRoutes.user},
    {'label': 'Chat', 'route': AppRoutes.chat},
  ];
}
