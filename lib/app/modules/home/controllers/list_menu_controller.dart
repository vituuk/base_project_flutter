import 'package:get/get.dart';

class ListMenuController extends GetxController {
  final count = 0.obs;

  void increaseCounter() {
    count.value++;
  }
}
