import 'dart:async';
import 'package:get/get.dart';

class UserCallController extends GetxController {
  // ── Call details passed via Get.arguments ───────────────────────────────────
  final userName = 'Alex Rivera'.obs;
  final avatarUrl = ''.obs;
  final isVideo = true.obs;

  // ── Control states ──────────────────────────────────────────────────────────
  final isMuted = false.obs;
  final isSpeaker = false.obs;
  final isFrontCamera = true.obs;

  // ── Call Timer ──────────────────────────────────────────────────────────────
  final durationSeconds = 0.obs;
  Timer? _timer;

  String get callDurationString {
    final minutes = (durationSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (durationSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      userName.value = args['name'] ?? 'Alex Rivera';
      avatarUrl.value = args['avatarUrl'] ?? '';
      isVideo.value = args['isVideo'] ?? true;
    }
    _startTimer();
  }

  void _startTimer() {
    // Start calling timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      durationSeconds.value++;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
  }

  void toggleVideo() {
    isVideo.value = !isVideo.value;
  }

  void toggleCamera() {
    isFrontCamera.value = !isFrontCamera.value;
  }

  void toggleSpeaker() {
    isSpeaker.value = !isSpeaker.value;
  }
}
