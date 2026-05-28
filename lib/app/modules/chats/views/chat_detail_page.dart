import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: msgs.length + 1, // +1 for date header
        itemBuilder: (context, index) {
          if (index == 0) return _buildDateDivider('Yesterday, 4:32 PM');

          final msg = msgs[index - 1];
          final isLast = index == msgs.length;
          final prevIsSameSender = index > 1 &&
              msgs[index - 2].isSent == msg.isSent;

          return MessageBubble(
            message: msg,
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
                    onLongPressStart: (_) => controller.startRecording(),
                    onLongPressEnd: (_) => controller.stopRecording(),
                    onTap: () {
                      Get.snackbar(
                        'Voice Message',
                        'Hold the microphone icon to record a voice message.',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
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
                  const SizedBox(width: 8),

                  // ── Send button (always visible) ─────────────────────────────
                  GestureDetector(
                    onTap: controller.sendMessage,
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
}

