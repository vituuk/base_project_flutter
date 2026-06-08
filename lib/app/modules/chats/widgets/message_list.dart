import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/theme_extensions.dart';
import '../controllers/chat_detail_controller.dart';
import 'message_bubble.dart';
import 'typing_indicator.dart';

class MessageList extends StatelessWidget {
  final ChatDetailController controller;

  const MessageList({super.key, required this.controller});

  Color get _primary => AppColors.primary;
  Color get _timeColor => AppColors.subtitle;

  @override
  Widget build(BuildContext context) {
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
          final prevIsSameSender = index > 1 && msgs[index - 2].isSent == msg.isSent;

          return MessageBubble(
            message: msg,
            messageIndex: index - 1,
            showAvatar: !msg.isSent && !prevIsSameSender,
            isLastOfGroup: isLast || (index < msgs.length && msgs[index].isSent != msg.isSent),
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
                      errorBuilder: (context, error, stackTrace) => CircleAvatar(
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
