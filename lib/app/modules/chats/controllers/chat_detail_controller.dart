import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart' as fp;

import '../../../core/constants/chats/chat_detail_message.dart';
import '../../../routes/app_routes.dart';
export '../../../core/constants/chats/chat_detail_message.dart'
    show ChatDetailMessage;

class ChatDetailController extends GetxController {
  // ── Contact info passed via Get.arguments ───────────────────────────────────
  final userName = ''.obs;
  final avatarUrl = ''.obs;
  final isOnline = false.obs;

  // ── Input state ─────────────────────────────────────────────────────────────
  // TextEditingController lives here so it survives widget rebuilds
  final inputController = TextEditingController();
  final isTyping = false.obs;
  final isPeerTyping = false.obs;
  final scrollController = ScrollController();
  final showEmojiPicker = false.obs;
  final showAttachmentOverlay = false.obs;
  final hasRecordedVoice = false.obs;
  final previewVoicePath = ''.obs;
  final previewDuration = 0.obs;
  final micDragY = 0.0.obs;
  final isDraggingMic = false.obs;
  final ImagePicker _picker = ImagePicker();
  final selectedImagePaths = <String>[].obs;

  final messages = <ChatDetailMessage>[...kChatDetailMessages].obs;
  final replyMessage = Rxn<ChatDetailMessage>();

  // ── Recording State ─────────────────────────────────────────────────────────
  final AudioRecorder recorder = AudioRecorder();
  final isRecording = false.obs;
  final recordingDuration = 0.obs;
  Timer? _recordingTimer;
  String? _localRecordPath;

  @override
  void onInit() {
    super.onInit();
    // Read contact info passed from the chat list
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      userName.value = args['name'] ?? '';
      avatarUrl.value = args['avatarUrl'] ?? '';
      isOnline.value = args['isOnline'] ?? false;
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    _recordingTimer?.cancel();
    recorder.dispose();
    super.onClose();
  }

  void onTextChanged(String value) {
    isTyping.value = value.trim().isNotEmpty;
  }

  void sendMessage() {
    final text = inputController.text.trim();
    if (text.isEmpty && selectedImagePaths.isEmpty) return;

    bool sentSomething = false;
    String lastMsg = "";

    if (selectedImagePaths.isNotEmpty) {
      for (final path in selectedImagePaths) {
        messages.add(ChatDetailMessage(
          text: 'Sent a photo',
          isSent: true,
          time: _currentTime(),
          isImage: true,
          imagePath: path,
          isRead: false,
        ));
      }
      selectedImagePaths.clear();
      sentSomething = true;
      lastMsg = "photo";
    }

    if (text.isNotEmpty) {
      final replyVal = replyMessage.value;
      messages.add(ChatDetailMessage(
        text: text,
        isSent: true,
        time: _currentTime(),
        isRead: false,
        repliedToText: replyVal?.text,
        repliedToSender: replyVal == null
            ? null
            : (replyVal.isSent ? 'You' : userName.value),
      ));
      inputController.clear();
      replyMessage.value = null;
      sentSomething = true;
      lastMsg = text;
    }

    isTyping.value = false;
    showEmojiPicker.value = false;
    showAttachmentOverlay.value = false;

    if (sentSomething) {
      scrollToBottom();
      _simulatePeerReply(lastMsg);
    }
  }

  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
    showAttachmentOverlay.value = false;
    if (showEmojiPicker.value) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void insertEmoji(String emoji) {
    final text = inputController.text;
    final textSelection = inputController.selection;
    
    int start = textSelection.start;
    int end = textSelection.end;

    if (start < 0) {
      start = text.length;
      end = text.length;
    }

    final newText = text.replaceRange(start, end, emoji);
    final int newOffset = start + emoji.length;
    
    inputController.text = newText;
    inputController.selection = TextSelection.collapsed(offset: newOffset);
    onTextChanged(newText);
  }

  void deleteEmoji() {
    final text = inputController.text;
    final textSelection = inputController.selection;
    if (text.isEmpty) return;

    int start = textSelection.start;
    int end = textSelection.end;

    if (start < 0) {
      start = text.length;
      end = text.length;
    }

    if (start == end) {
      if (start == 0) return;
      final prefix = text.substring(0, start).characters;
      if (prefix.isNotEmpty) {
        final newPrefix = prefix.skipLast(1).toString();
        final suffix = text.substring(end);
        inputController.text = newPrefix + suffix;
        inputController.selection = TextSelection.collapsed(offset: newPrefix.length);
      }
    } else {
      final newText = text.replaceRange(start, end, '');
      inputController.text = newText;
      inputController.selection = TextSelection.collapsed(offset: start);
    }
    onTextChanged(inputController.text);
  }

  Future<void> pickAndSendImage(bool fromCamera) async {
    try {
      if (fromCamera) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (image != null) {
          selectedImagePaths.add(image.path);
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 85,
        );
        if (images.isNotEmpty) {
          selectedImagePaths.addAll(images.map((img) => img.path));
        }
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar(
        'Error',
        'Could not access gallery or camera.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  Future<void> pickAndSendFile() async {
    try {
      final fp.FilePickerResult? result = await fp.FilePicker.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.single;
        final fileName = platformFile.name;
        final fileSize = (platformFile.size / (1024 * 1024)).toStringAsFixed(1);
        
        messages.add(ChatDetailMessage(
          text: fileName,
          isSent: true,
          time: currentTime(),
          isRead: false,
          isFile: true,
          fileName: fileName,
          fileSize: '$fileSize MB',
        ));
        scrollToBottom();
        _simulatePeerReply(fileName);
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
      Get.snackbar(
        'Error',
        'Could not access files on this device.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> startCall(bool isVideo) async {
    final result = await Get.toNamed(
      AppRoutes.userCall,
      arguments: {
        'name': userName.value,
        'avatarUrl': avatarUrl.value,
        'isVideo': isVideo,
      },
    );

    if (result != null && result is Map) {
      final callType = result['callType'] as String?;
      final duration = result['duration'] as String?;

      messages.add(ChatDetailMessage(
        text: callType == 'outgoing' ? 'Outgoing Call' : 'Canceled Call',
        isSent: true,
        time: _currentTime(),
        isCallLog: true,
        callType: callType,
        callDuration: duration,
      ));
    }
  }

  // ── Voice Recording Methods ────────────────────────────────────────────────
  Future<void> startRecording() async {
    try {
      if (await recorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        _localRecordPath = '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await recorder.start(const RecordConfig(), path: _localRecordPath!);
        
        recordingDuration.value = 0;
        isRecording.value = true;
        
        _recordingTimer?.cancel();
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          recordingDuration.value++;
        });
      } else {
        Get.snackbar(
          'Microphone Permission Required',
          'Please grant microphone permission to record voice notes.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Error starting record: $e");
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;
    try {
      _recordingTimer?.cancel();
      final path = await recorder.stop();
      isRecording.value = false;

      if (path != null) {
        previewVoicePath.value = path;
        previewDuration.value = recordingDuration.value;
        hasRecordedVoice.value = true;
      }
    } catch (e) {
      print("Error stopping record: $e");
      isRecording.value = false;
    }
  }

  Future<void> cancelRecording() async {
    if (!isRecording.value) return;
    try {
      _recordingTimer?.cancel();
      await recorder.stop();
      isRecording.value = false;
    } catch (e) {
      print("Error cancelling record: $e");
      isRecording.value = false;
    }
  }

  String currentTime() => _currentTime();

  String _currentTime() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void triggerPeerReply(String userMessage) {
    _simulatePeerReply(userMessage);
  }

  void _simulatePeerReply(String userMessage) {
    isPeerTyping.value = true;
    scrollToBottom();

    Timer(const Duration(milliseconds: 2000), () {
      isPeerTyping.value = false;

      String replyText = "I received your message! I'll check and get back to you soon.";
      final cleanMsg = userMessage.toLowerCase().trim();

      if (cleanMsg.contains('hello') || cleanMsg.contains('hi') || cleanMsg.contains('hey')) {
        replyText = "Hello! Hope you're doing well. What's on your mind?";
      } else if (cleanMsg.contains('meeting') || cleanMsg.contains('finalize')) {
        replyText = "Yes, let's meet tomorrow morning to finalize the slide deck. How does 10 AM sound?";
      } else if (cleanMsg.contains('conversion') || cleanMsg.contains('rate')) {
        replyText = "That 12% increase is fantastic! The slide deck is going to look great for the board.";
      } else if (cleanMsg.contains('photo') || cleanMsg.contains('image')) {
        replyText = "Wow, that looks great! Thanks for sharing.";
      } else if (cleanMsg.contains('file') || cleanMsg.contains('document') || cleanMsg.endsWith('.pdf') || cleanMsg.endsWith('.docx') || cleanMsg.endsWith('.xlsx')) {
        replyText = "Got the file! I'll review it and let you know my feedback.";
      } else if (cleanMsg.contains('location') || cleanMsg.contains('📍')) {
        replyText = "Thanks for the location! I'm on my way.";
      } else if (cleanMsg.contains('how are you')) {
        replyText = "I'm doing great, thanks for asking! Hope you're having a productive day.";
      } else if (cleanMsg.contains('bye') || cleanMsg.contains('goodbye')) {
        replyText = "Goodbye! Speak to you later.";
      } else if (cleanMsg.isEmpty) {
        replyText = "👍";
      }

      messages.add(ChatDetailMessage(
        text: replyText,
        isSent: false,
        time: _currentTime(),
        isRead: false,
      ));
    });
  }

  void sendPreviewVoice() {
    if (!hasRecordedVoice.value || previewVoicePath.value.isEmpty) return;

    messages.add(ChatDetailMessage(
      text: 'Voice Message',
      isSent: true,
      time: _currentTime(),
      isVoice: true,
      voicePath: previewVoicePath.value,
      voiceDuration: previewDuration.value,
    ));

    hasRecordedVoice.value = false;
    previewVoicePath.value = '';
    previewDuration.value = 0;

    scrollToBottom();
    _simulatePeerReply('Voice Message');
  }

  void discardPreviewVoice() {
    hasRecordedVoice.value = false;
    previewVoicePath.value = '';
    previewDuration.value = 0;
  }

  void onMicDragStart(DragStartDetails details) {
    isDraggingMic.value = true;
    micDragY.value = 0.0;
  }

  void onMicDragUpdate(DragUpdateDetails details) {
    double newY = micDragY.value - details.delta.dy;
    if (newY < 0) newY = 0;
    if (newY > 100) newY = 100;
    micDragY.value = newY;
  }

  void onMicDragEnd(DragEndDetails details) {
    isDraggingMic.value = false;
    if (micDragY.value >= 60.0) {
      discardPreviewVoice();
      Get.snackbar(
        'Deleted',
        'Voice message deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    }
    micDragY.value = 0.0;
  }

  void onMicLongPressMove(LongPressMoveUpdateDetails details) {
    double newY = -details.localOffsetFromOrigin.dy;
    if (newY < 0) newY = 0;
    if (newY > 100) newY = 100;
    micDragY.value = newY;
  }

  void onMicLongPressEnd(LongPressEndDetails details) {
    isDraggingMic.value = false;
    final draggedToDelete = micDragY.value >= 60.0;
    micDragY.value = 0.0;

    if (draggedToDelete) {
      cancelRecording();
      Get.snackbar(
        'Deleted',
        'Voice message deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    } else {
      stopRecording();
    }
  }

  void reactToMessage(int index, String emoji) {
    if (index >= 0 && index < messages.length) {
      final msg = messages[index];
      final newReaction = msg.reaction == emoji ? null : emoji;
      messages[index] = msg.copyWith(reaction: newReaction);
    }
  }
}
