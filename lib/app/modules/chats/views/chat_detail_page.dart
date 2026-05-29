import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/chat_detail_controller.dart';
import '../widgets/action_button.dart';
import '../widgets/pulsing_record_dot.dart';
import '../widgets/emoji_picker_panel.dart';
import '../widgets/options_sheet.dart';
import '../widgets/message_bubble.dart';

class ChatDetailPage extends GetView<ChatDetailController> {
  const ChatDetailPage({super.key});

  // ── Palette ─────────────────────────────────────────────────────────────────
  static Color get _bg => AppColors.bg;
  static Color get _primary => AppColors.primary;
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;
  static Color get _timeColor => AppColors.subtitle;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) => Scaffold(
        backgroundColor: _bg,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(child: _buildMessageList()),
                _buildInputBar(context),
                Obx(() {
                  if (controller.showEmojiPicker.value) {
                    return EmojiPickerPanel(controller: controller);
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
            Obx(() {
              if (controller.showAttachmentOverlay.value) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => controller.showAttachmentOverlay.value = false,
                      behavior: HitTestBehavior.opaque,
                      child: const SizedBox.expand(),
                    ),
                    _buildAttachmentOverlay(context),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      leadingWidth: 40,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: _darkText, size: 20),
        ),
      ),
      title: Obx(() => GestureDetector(
        onTap: () {
          Get.toNamed(
            AppRoutes.profile,
            arguments: {
              'isSelf': false,
              'name': controller.userName.value,
              'avatarUrl': controller.avatarUrl.value,
              'isOnline': controller.isOnline.value,
              'username': '@${controller.userName.value.toLowerCase().replaceAll(' ', '_')}',
              'mobile': controller.userName.value == 'Alex Rivera' ? '+855 12777333' : '+855 12888999',
              'bio': 'Hi',
              'status': controller.isOnline.value ? 'online' : 'last seen recently',
            },
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            // Avatar with online dot
            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFE8ECF5), width: 1.5),
                  ),
                  child: ClipOval(
                    child: controller.avatarUrl.value.isNotEmpty
                        ? Image.network(
                            controller.avatarUrl.value,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => CircleAvatar(
                              backgroundColor: const Color(0xFFDDE6F9),
                              child: Icon(Icons.person_rounded,
                                  color: _primary, size: 22),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: const Color(0xFFDDE6F9),
                            child: Icon(Icons.person_rounded,
                                color: _primary, size: 22),
                          ),
                  ),
                ),
                if (controller.isOnline.value)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.userName.value,
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (controller.isOnline.value)
                  Text(
                    'Active now',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ],
        ),
      )),
      actions: [
        ActionButton(
          svgPath: 'assets/icons/camera.svg',
          width: 20,
          height: 20,
          onTap: () => controller.startCall(true),
        ),
        const SizedBox(width: 14),
        ActionButton(
          svgPath: 'assets/icons/call.svg',
          width: 18,
          height: 18,
          onTap: () => controller.startCall(false),
        ),
        const SizedBox(width: 14),
        ActionButton(svgPath: 'assets/icons/search.svg', width: 16, height: 16, onTap: () {}),
        const SizedBox(width: 10),
        // More options
        Builder(
          builder: (ctx) => GestureDetector(
            onTap: () => _showOptionsSheet(ctx),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.more_vert_rounded, color: _darkText, size: 22),
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Options Bottom Sheet ─────────────────────────────────────────────────────
  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => OptionsSheet(controller: controller),
    );
  }

  void _showPhotoPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Send Photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                title: Text('Take Photo', style: TextStyle(color: AppColors.text)),
                onTap: () {
                  Get.back();
                  controller.pickAndSendImage(true);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library_rounded, color: AppColors.primary),
                title: Text('Choose from Gallery', style: TextStyle(color: AppColors.text)),
                onTap: () {
                  Get.back();
                  controller.pickAndSendImage(false);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOverlay(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double emojiPickerHeight = controller.showEmojiPicker.value ? 280.0 : 0.0;
    final double bottomPadding = MediaQuery.of(context).padding.bottom + 64.0 + keyboardHeight + emojiPickerHeight;

    return Positioned(
      bottom: bottomPadding,
      left: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOverlayPill(
            icon: Icons.location_on_rounded,
            label: 'Location',
            onTap: () async {
              controller.showAttachmentOverlay.value = false;
              final result = await Get.toNamed(AppRoutes.locationPicker);
              if (result != null && result is Map<String, dynamic>) {
                final double lat = result['latitude'];
                final double lng = result['longitude'];
                final String address = result['address'];
                final mapUrl = 'https://maps.google.com/?q=$lat,$lng';

                controller.messages.add(ChatDetailMessage(
                  text: '📍 Location Shared\n$address\n$mapUrl',
                  isSent: true,
                  time: controller.currentTime(),
                  isRead: false,
                ));
                controller.scrollToBottom();
                controller.triggerPeerReply('📍 Location Shared');
              }
            },
          ),
          const SizedBox(height: 8),
          _buildOverlayPill(
            icon: Icons.description_rounded,
            label: 'File',
            onTap: () {
              controller.showAttachmentOverlay.value = false;
              controller.pickAndSendFile();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayPill({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2046E8),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Message List ─────────────────────────────────────────────────────────────
  Widget _buildMessageList() {
    return Obx(() {
      final msgs = controller.messages;
      final isTyping = controller.isPeerTyping.value;
      final totalCount = msgs.length + 1 + (isTyping ? 1 : 0);

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: totalCount,
        itemBuilder: (context, index) {
          if (index == 0) return _buildDateDivider('Yesterday, 4:32 PM');

          if (isTyping && index == totalCount - 1) {
            return _buildTypingIndicator(context);
          }

          final msg = msgs[index - 1];
          final isLast = index == msgs.length;
          final prevIsSameSender = index > 1 &&
              msgs[index - 2].isSent == msg.isSent;

          return MessageBubble(
            message: msg,
            messageIndex: index - 1,
            showAvatar: !msg.isSent && !prevIsSameSender,
            isLastOfGroup: isLast ||
                (index < msgs.length && msgs[index].isSent != msg.isSent),
          );
        },
      );
    });
  }

  Widget _buildDateDivider(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _timeColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ── Input Bar ────────────────────────────────────────────────────────────────
  Widget _buildInputBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply Preview Layout
            Obx(() {
              final replyVal = controller.replyMessage.value;
              if (replyVal == null) return const SizedBox.shrink();
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final previewBg = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7);
              final senderName = replyVal.isSent ? 'You' : controller.userName.value;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: previewBg,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.divider,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 3.5,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2046E8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            senderName,
                            style: const TextStyle(
                              color: Color(0xFF2046E8),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            replyVal.isCallLog
                                ? 'Call Log'
                                : replyVal.isVoice
                                    ? 'Voice Message'
                                    : replyVal.isImage
                                        ? 'Photo'
                                        : replyVal.isFile
                                            ? 'File'
                                            : replyVal.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      color: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
                      onPressed: () => controller.replyMessage.value = null,
                    ),
                  ],
                ),
              );
            }),
            // Image Preview List
            Obx(() {
              if (controller.selectedImagePaths.isEmpty) {
                return const SizedBox.shrink();
              }
              return Container(
                height: 84,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.divider,
                      width: 1,
                    ),
                  ),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.selectedImagePaths.length,
                  itemBuilder: (context, index) {
                    final path = controller.selectedImagePaths[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(path),
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedImagePaths.removeAt(index);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Obx(() => Row(
                children: [
                  if (controller.isRecording.value) ...[
                    const PulsingRecordDot(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() {
                        final durationSecs = controller.recordingDuration.value;
                        final m = (durationSecs ~/ 60).toString().padLeft(2, '0');
                        final s = (durationSecs % 60).toString().padLeft(2, '0');
                        return Text(
                          'Recording $m:$s',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }),
                    ),
                    GestureDetector(
                      onTap: () => controller.cancelRecording(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: _subtitleColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ] else if (controller.hasRecordedVoice.value) ...[
                    Expanded(
                      child: VoicePreviewPill(
                        voicePath: controller.previewVoicePath.value,
                        duration: controller.previewDuration.value,
                      ),
                    ),
                  ] else ...[
                    // ── Add / attachment button ──────────────────────────────────
                    GestureDetector(
                      onTap: () {
                        controller.showEmojiPicker.value = false;
                        controller.showAttachmentOverlay.value = !controller.showAttachmentOverlay.value;
                      },
                      behavior: HitTestBehavior.opaque,
                      child: SvgPicture.asset(
                        'assets/icons/add-function.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 6),

                    // ── Send photo / sticker button ──────────────────────────────
                    Builder(
                      builder: (ctx) => GestureDetector(
                        onTap: () => _showPhotoPickerSheet(ctx),
                        behavior: HitTestBehavior.opaque,
                        child: SvgPicture.asset(
                          'assets/icons/send-photo.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ── Text field ───────────────────────────────────────────────
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: controller.inputController,
                                onChanged: controller.onTextChanged,
                                onTap: () {
                                  controller.showEmojiPicker.value = false;
                                },
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _darkText,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: _timeColor,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            // Emoji button
                            Obx(() => GestureDetector(
                              onTap: controller.toggleEmojiPicker,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  controller.showEmojiPicker.value
                                      ? Icons.emoji_emotions
                                      : Icons.emoji_emotions_outlined,
                                  color: controller.showEmojiPicker.value
                                      ? _primary
                                      : _timeColor,
                                  size: 22,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(width: 8),

                  // ── Voice button (always visible) ────────────────────────────
                  GestureDetector(
                    onVerticalDragStart: controller.hasRecordedVoice.value ? controller.onMicDragStart : null,
                    onVerticalDragUpdate: controller.hasRecordedVoice.value ? controller.onMicDragUpdate : null,
                    onVerticalDragEnd: controller.hasRecordedVoice.value ? controller.onMicDragEnd : null,
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        if ((controller.hasRecordedVoice.value || controller.isRecording.value) && controller.micDragY.value > 0)
                          Positioned(
                            top: -64,
                            child: Builder(builder: (context) {
                              final dragY = controller.micDragY.value;
                              final opacity = (dragY / 40.0).clamp(0.0, 1.0);
                              final scale = dragY >= 60.0 ? 1.3 : (0.5 + (dragY / 60.0) * 0.5).clamp(0.5, 1.0);
                              final color = dragY >= 60.0 ? const Color(0xFFEF4444) : const Color(0xFFEF4444).withValues(alpha: 0.85);

                              return Opacity(
                                opacity: opacity,
                                child: Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: dragY >= 60.0 ? 0.3 : 0.15),
                                          blurRadius: dragY >= 60.0 ? 12 : 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        Transform.translate(
                          offset: Offset(0, -controller.micDragY.value),
                          child: GestureDetector(
                            onLongPressStart: controller.hasRecordedVoice.value ? null : (_) => controller.startRecording(),
                            onLongPressMoveUpdate: controller.hasRecordedVoice.value ? null : (details) => controller.onMicLongPressMove(details),
                            onLongPressEnd: controller.hasRecordedVoice.value ? null : (details) => controller.onMicLongPressEnd(details),
                            onTap: () {
                              if (controller.hasRecordedVoice.value) {
                                Get.snackbar(
                                  'Drag to Delete',
                                  'Hold the microphone icon and drag it UP to delete the recording.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 2),
                                );
                              } else {
                                Get.snackbar(
                                  'Voice Message',
                                  'Hold the microphone icon to record a voice message.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            },
                            behavior: HitTestBehavior.opaque,
                            child: SvgPicture.asset(
                              'assets/icons/send-voice.svg',
                              width: 24,
                              height: 24,
                              colorFilter: controller.isRecording.value
                                  ? const ColorFilter.mode(Colors.redAccent, BlendMode.srcIn)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ── Send button (always visible) ─────────────────────────────
                  GestureDetector(
                    onTap: () {
                      if (controller.hasRecordedVoice.value) {
                        controller.sendPreviewVoice();
                      } else {
                        controller.sendMessage();
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SvgPicture.asset(
                      'assets/icons/send-message.svg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: controller.avatarUrl.value.isNotEmpty
                  ? Image.network(
                      controller.avatarUrl.value,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => CircleAvatar(
                        backgroundColor: const Color(0xFFDDE6F9),
                        child: Icon(Icons.person_rounded, color: _primary, size: 16),
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: const Color(0xFFDDE6F9),
                      child: Icon(Icons.person_rounded, color: _primary, size: 16),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.isDarkMode ? AppColors.card : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const TypingIndicator(),
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < 3; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      _controllers[i].repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color dotColor = AppColors.isDarkMode ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return FadeTransition(
          opacity: _animations[index],
          child: ScaleTransition(
            scale: _animations[index],
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class VoicePreviewPill extends StatefulWidget {
  const VoicePreviewPill({
    super.key,
    required this.voicePath,
    required this.duration,
  });

  final String voicePath;
  final int duration;

  @override
  State<VoicePreviewPill> createState() => _VoicePreviewPillState();
}

class _VoicePreviewPillState extends State<VoicePreviewPill> {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.stopped;

  StreamSubscription? _stateSubscription;
  StreamSubscription? _completeSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _stateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });

    _completeSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _playerState = PlayerState.stopped;
        });
      }
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _completeSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (widget.voicePath.isEmpty) return;

    if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.voicePath));
    }
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isPlaying = _playerState == PlayerState.playing;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF2046E8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(24, (index) {
                final heights = [8, 14, 10, 18, 12, 22, 14, 8, 16, 20, 12, 10, 8, 14, 10, 18, 12, 22, 14, 8, 16, 20, 12, 10];
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    height: heights[index % heights.length].toDouble(),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatDuration(widget.duration),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

