import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/chats/chat_detail_message.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/chat_detail_controller.dart';

class ChatDetailPage extends GetView<ChatDetailController> {
  const ChatDetailPage({super.key});

  // ── Palette ─────────────────────────────────────────────────────────────────
  static Color get _bg => AppColors.bg;
  static Color get _primary => AppColors.primary;
  static Color get _sentBubble => AppColors.primary;
  static Color get _receivedBubble => AppColors.card;
  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;
  static Color get _timeColor => AppColors.subtitle;
  static Color get _inputBg => AppColors.card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInputBar(),
        ],
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
          padding: EdgeInsets.only(left: 12),
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
                              backgroundColor: Color(0xFFDDE6F9),
                              child: Icon(Icons.person_rounded,
                                  color: _primary, size: 22),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Color(0xFFDDE6F9),
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
                    style: TextStyle(
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
        _ActionButton(
          svgPath: 'lib/assets/img/camera.svg',
          width: 20,
          height: 20,
          onTap: () {
            Get.toNamed(
              AppRoutes.userCall,
              arguments: {
                'name': controller.userName.value,
                'avatarUrl': controller.avatarUrl.value,
                'isVideo': true,
              },
            );
          },
        ),
        const SizedBox(width: 14),
        _ActionButton(
          svgPath: 'lib/assets/img/call.svg',
          width: 18,
          height: 18,
          onTap: () {
            Get.toNamed(
              AppRoutes.userCall,
              arguments: {
                'name': controller.userName.value,
                'avatarUrl': controller.avatarUrl.value,
                'isVideo': false,
              },
            );
          },
        ),
        const SizedBox(width: 14),
        _ActionButton(svgPath: 'lib/assets/img/search.svg', width: 16, height: 16, onTap: () {}),
        const SizedBox(width: 10),
        // More options
        Builder(
          builder: (ctx) => GestureDetector(
            onTap: () => _showOptionsSheet(ctx),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
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
      builder: (_) => _OptionsSheet(controller: controller),
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

          return _MessageBubble(
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
  Widget _buildInputBar() {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // ── Add / attachment button ──────────────────────────────────
              GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(
                  'lib/assets/img/add-function.svg',
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(width: 6),

              // ── Send photo / sticker button ──────────────────────────────
              GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(
                  'lib/assets/img/send-photo.svg',
                  width: 20,
                  height: 20,
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
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.emoji_emotions_outlined,
                              color: _timeColor, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ── Voice button (always visible) ────────────────────────────
              GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(
                  'lib/assets/img/send-voice.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(width: 8),

              // ── Send button (always visible) ─────────────────────────────
              GestureDetector(
                onTap: controller.sendMessage,
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(
                  'lib/assets/img/send-message.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Action Button (AppBar right) ──────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.svgPath,
    required this.onTap,
    this.width = 28,
    this.height = 28,
  });
  final String svgPath;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(
        svgPath,
        width: width,
        height: height,
      ),
    );
  }
}

// ── Circle Input Button ────────────────────────────────────────────────────────
class _CircleInputButton extends StatelessWidget {
  const _CircleInputButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

// ── Message Bubble ─────────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.isLastOfGroup,
  });

  final ChatDetailMessage message;
  final bool showAvatar;
  final bool isLastOfGroup;

  static const Color _primary = Color(0xFF2046E8);
  static const Color _timeColor = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    final bool isSent = message.isSent;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isLastOfGroup ? 8 : 3,
        left: isSent ? 60 : 0,
        right: isSent ? 0 : 60,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Avatar for received messages
          if (!isSent) ...[
            if (showAvatar)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: Image.network(
                    'https://randomuser.me/api/portraits/men/32.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => CircleAvatar(
                      backgroundColor: Color(0xFFDDE6F9),
                      child:
                          Icon(Icons.person_rounded, color: _primary, size: 16),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(width: 32),
            const SizedBox(width: 8),
          ],

          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSent
                        ? _primary
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isSent ? 18 : 4),
                      bottomRight: Radius.circular(isSent ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSent ? Colors.white : const Color(0xFF111827),
                      height: 1.45,
                    ),
                  ),
                ),

                // Time + read receipt
                if (isLastOfGroup)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isSent
                              ? 'Read ${message.time}'
                              : message.time,
                          style: TextStyle(
                              fontSize: 11, color: _timeColor),
                        ),
                        if (isSent && message.isRead) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.done_all_rounded,
                              size: 14, color: _primary),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Options Bottom Sheet ───────────────────────────────────────────────────────
class _OptionsSheet extends StatelessWidget {
  const _OptionsSheet({required this.controller});
  final ChatDetailController controller;

  static const Color _primary = Color(0xFF2046E8);
  static const Color _danger = Color(0xFFEF4444);
  static const Color _textColor = Color(0xFF111827);
  static const Color _subtitleColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 4),

            // ── Options list ─────────────────────────────────────────────
            _OptionTile(
              icon: Icons.call_rounded,
              iconColor: _primary,
              label: 'Call with group',
              labelColor: _primary,
              onTap: () => Get.back(),
            ),
            _OptionTile(
              icon: Icons.push_pin_outlined,
              label: 'Pin',
              onTap: () => Get.back(),
            ),
            _OptionTile(
              icon: Icons.notifications_off_outlined,
              label: 'Mute',
              onTap: () => Get.back(),
            ),
            _OptionTile(
              icon: Icons.group_add_outlined,
              label: 'Add members',
              onTap: () => Get.back(),
            ),
            _OptionTile(
              icon: Icons.mark_chat_unread_outlined,
              label: 'Mark as unread',
              onTap: () => Get.back(),
            ),

            // Divider before destructive actions
            const Divider(height: 1, indent: 20, endIndent: 20),

            _OptionTile(
              icon: Icons.exit_to_app_rounded,
              iconColor: _danger,
              label: 'Leave group',
              labelColor: _danger,
              onTap: () => Get.back(),
            ),
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              iconColor: _danger,
              label: 'Delete',
              labelColor: _danger,
              onTap: () {
                Get.back(); // close sheet
                _confirmDelete(context);
              },
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete conversation?',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
        ),
        content: Obx(() => Text(
              'This will permanently delete your conversation with ${controller.userName.value}.',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: TextStyle(color: Color(0xFF6B7280))),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // close dialog
              Get.back(); // go back to chat list
            },
            child: Text('Delete',
                style: TextStyle(
                    color: Color(0xFFEF4444), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ── Single option tile ────────────────────────────────────────────────────────
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor = const Color(0xFF111827),
    this.labelColor = const Color(0xFF111827),
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
