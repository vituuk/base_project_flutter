import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/chats/chat_detail_message.dart';
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

  // ── Messages (seeded from constants, then extended at runtime) ───────────────
  final messages = <ChatDetailMessage>[...kChatDetailMessages].obs;

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
    super.onClose();
  }

  void onTextChanged(String value) {
    isTyping.value = value.trim().isNotEmpty;
  }

  void sendMessage() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;
    messages.add(ChatDetailMessage(
      text: text,
      isSent: true,
      time: _currentTime(),
      isRead: false,
    ));
    inputController.clear();
    isTyping.value = false;
  }

  String _currentTime() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
}
