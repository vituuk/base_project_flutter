import 'dart:async';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

class UserCallController extends GetxController {
  // ── Call details passed via Get.arguments ───────────────────────────────────
  final userName = 'Alex Rivera'.obs;
  final avatarUrl = ''.obs;
  final isVideo = true.obs;

  // ── Control states ──────────────────────────────────────────────────────────
  final isMuted = false.obs;
  final isSpeaker = false.obs;
  final isFrontCamera = true.obs;

  // ── Camera Controller ───────────────────────────────────────────────────────
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  final isCameraInitialized = false.obs;

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
    if (isVideo.value) {
      initCamera();
    }
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        Get.snackbar(
          'Camera Warning',
          'No cameras available on this device.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      await _updateCameraController();
    } catch (e) {
      print("Error fetching cameras: $e");
      Get.snackbar(
        'Camera Error',
        'Error fetching cameras: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _updateCameraController() async {
    if (cameras.isEmpty) return;

    if (cameraController != null) {
      isCameraInitialized.value = false;
      await cameraController!.dispose();
      cameraController = null;
    }

    CameraDescription selectedCamera = cameras.first;
    for (final camera in cameras) {
      if (isFrontCamera.value && camera.lensDirection == CameraLensDirection.front) {
        selectedCamera = camera;
        break;
      } else if (!isFrontCamera.value && camera.lensDirection == CameraLensDirection.back) {
        selectedCamera = camera;
        break;
      }
    }

    cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: !isMuted.value,
    );

    try {
      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      print("Camera initialization error: $e");
      Get.snackbar(
        'Camera Initialization Error',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
    cameraController?.dispose();
    super.onClose();
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
  }

  void toggleVideo() {
    isVideo.value = !isVideo.value;
    if (isVideo.value) {
      initCamera();
    } else {
      if (cameraController != null) {
        isCameraInitialized.value = false;
        cameraController!.dispose();
        cameraController = null;
      }
    }
  }

  void toggleCamera() {
    isFrontCamera.value = !isFrontCamera.value;
    if (isVideo.value) {
      _updateCameraController();
    }
  }

  void toggleSpeaker() {
    isSpeaker.value = !isSpeaker.value;
  }

  void endCall() {
    final durationSecs = durationSeconds.value;
    final isVideoCall = isVideo.value;

    String durationString = '';
    if (durationSecs >= 60) {
      final m = durationSecs ~/ 60;
      final s = durationSecs % 60;
      durationString = '$m min ${s}sec';
    } else {
      durationString = '${durationSecs}sec';
    }

    Get.back(result: {
      'callType': durationSecs > 0 ? 'outgoing' : 'canceled',
      'duration': durationString,
      'isVideo': isVideoCall,
    });
  }
}
