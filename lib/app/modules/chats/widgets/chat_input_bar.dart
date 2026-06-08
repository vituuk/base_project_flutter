import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/theme/theme_extensions.dart';
import '../controllers/chat_detail_controller.dart';
import 'pulsing_record_dot.dart';
import 'voice_preview_pill.dart';

class ChatInputBar extends StatelessWidget {
  final ChatDetailController controller;

  const ChatInputBar({super.key, required this.controller});

  Color get _subtitleColor => AppColors.subtitle;
  Color get _darkText => AppColors.text;
  Color get _timeColor => AppColors.subtitle;
  Color get _primary => AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
}
