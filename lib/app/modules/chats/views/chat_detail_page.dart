import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/chat_detail_controller.dart';
import '../widgets/emoji_picker_panel.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/message_list.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/attachment_overlay.dart';

class ChatDetailPage extends GetView<ChatDetailController> {
  const ChatDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) => Scaffold(
        backgroundColor: AppColors.bg,
        appBar: ChatAppBar(controller: controller),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(child: MessageList(controller: controller)),
                ChatInputBar(controller: controller),
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
                    AttachmentOverlay(controller: controller),
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
}
