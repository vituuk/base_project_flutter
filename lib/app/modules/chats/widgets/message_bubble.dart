import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../controllers/chat_detail_controller.dart';
import '../../../routes/app_routes.dart';

void _showReactionDialog(BuildContext context, int messageIndex, ChatDetailMessage message) {
  final controller = Get.find<ChatDetailController>();
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final cardColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7);
  final bottomBarColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Spacer or tap area to close
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(color: Colors.transparent),
                ),
              ),
              // Reaction capsule
              Container(
                margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...['❤️', '😂', '😮', '😢', '😡', '👍'].map((emoji) {
                        final isSelected = message.reaction == emoji;
                        return GestureDetector(
                          onTap: () {
                            controller.reactToMessage(messageIndex, emoji);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: isSelected
                                ? BoxDecoration(
                                    color: const Color(0xFF2046E8).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                : null,
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        );
                      }),
                      // Plus Button
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Get.snackbar(
                            'Emojis',
                            'More reactions feature coming soon!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF2046E8).withValues(alpha: 0.8),
                            colorText: Colors.white,
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08),
                          ),
                          child: Icon(
                            Icons.add,
                            color: isDark ? Colors.white : Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Actions Menu bar at bottom
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: bottomBarColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(context, Icons.reply_rounded, 'Reply', () {
                      Navigator.of(context).pop();
                      controller.replyMessage.value = message;
                    }),
                    _buildActionButton(context, Icons.copy_rounded, 'Copy', () {
                      Navigator.of(context).pop();
                      Clipboard.setData(ClipboardData(text: message.text));
                      Get.snackbar(
                        'Copied',
                        'Message copied to clipboard',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF2046E8).withValues(alpha: 0.8),
                        colorText: Colors.white,
                      );
                    }),
                    _buildActionButton(context, Icons.translate_rounded, 'Translate', () {
                      Navigator.of(context).pop();
                      Get.snackbar(
                        'Translate',
                        'Translating message text...',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF2046E8).withValues(alpha: 0.8),
                        colorText: Colors.white,
                      );
                    }),
                    _buildActionButton(context, Icons.menu_rounded, 'More', () {
                      Navigator.of(context).pop();
                      _showMoreOptions(context, messageIndex, message);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final activeColor = const Color(0xFF2046E8);
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: activeColor,
          size: 24,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF111827),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

void _showMoreOptions(BuildContext context, int messageIndex, ChatDetailMessage message) {
  final controller = Get.find<ChatDetailController>();
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
  final textColor = isDark ? Colors.white : const Color(0xFF111827);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('More Actions', style: TextStyle(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
              title: const Text('Delete Message', style: TextStyle(color: Color(0xFFEF4444))),
              onTap: () {
                controller.messages.removeAt(messageIndex);
                Navigator.of(context).pop();
                Get.snackbar(
                  'Deleted',
                  'Message deleted',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.8),
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share_rounded, color: textColor),
              title: Text('Forward Message', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.of(context).pop();
                Get.snackbar(
                  'Forward',
                  'Forwarding feature coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF2046E8).withValues(alpha: 0.8),
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildReactionBadge(BuildContext context, String? reaction, bool isSent) {
  if (reaction == null || reaction.isEmpty) {
    return const SizedBox.shrink();
  }
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Positioned(
    bottom: -8,
    right: isSent ? 12 : null,
    left: isSent ? null : 12,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
          width: 1.5,
        ),
      ),
      child: Text(
        reaction,
        style: const TextStyle(fontSize: 12),
      ),
    ),
  );
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.messageIndex,
    required this.showAvatar,
    required this.isLastOfGroup,
  });

  final ChatDetailMessage message;
  final int messageIndex;
  final bool showAvatar;
  final bool isLastOfGroup;

  static const Color _primary = Color(0xFF2046E8);
  static const Color _timeColor = Color(0xFF9CA3AF);

  Widget _buildCallLogBubble(BuildContext context) {
    final controller = Get.find<ChatDetailController>();
    final bool isMissed = message.callType == 'missed';
    final bool isCanceled = message.callType == 'canceled';

    if (isMissed) {
      return Container(
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Missed Call',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          message.time,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.call_missed_rounded,
                      color: Color(0xFFEF4444),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => controller.startCall(false),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.phone_callback_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Call Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      final title = isCanceled ? 'Canceled Call' : 'Outgoing Call';
      final buttonText = isCanceled ? 'Try Again' : 'Call Again';
      final subtitle = isCanceled 
          ? message.time 
          : '${message.time}, ${message.callDuration ?? "0sec"}';

      return Container(
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: Color(0xFF2046E8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.call_made_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => controller.startCall(false),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone_rounded,
                      color: Color(0xFF2046E8),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      buttonText,
                      style: const TextStyle(
                        color: Color(0xFF2046E8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatDetailController>();
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
          if (!isSent) ...[
            if (showAvatar)
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
                            child:
                                Icon(Icons.person_rounded, color: _primary, size: 16),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: const Color(0xFFDDE6F9),
                          child:
                              Icon(Icons.person_rounded, color: _primary, size: 16),
                        ),
                ),
              )
            else
              const SizedBox(width: 32),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: message.isCallLog
                ? _buildCallLogBubble(context)
                : message.isVoice
                    ? VoiceBubble(
                        message: message,
                        isLastOfGroup: isLastOfGroup,
                        messageIndex: messageIndex,
                      )
                    : message.isImage
                        ? ImageBubble(
                            message: message,
                            isLastOfGroup: isLastOfGroup,
                            messageIndex: messageIndex,
                          )
                        : message.isFile
                            ? FileBubble(
                                message: message,
                                isLastOfGroup: isLastOfGroup,
                                messageIndex: messageIndex,
                              )
                            : Column(
                            crossAxisAlignment: isSent
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                 onLongPress: () => _showReactionDialog(context, messageIndex, message),
                                 onTap: () async {
                                   if (message.text.contains('📍') || message.text.contains('openstreetmap.org') || message.text.contains('maps.google.com')) {
                                     double latitude = 10.790;
                                     double longitude = 104.562;
                                     bool parsed = false;

                                     final RegExp googleRegExp = RegExp(r'[?&]q=(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?)');
                                     final googleMatch = googleRegExp.firstMatch(message.text);
                                     if (googleMatch != null && googleMatch.groupCount >= 2) {
                                       try {
                                         latitude = double.parse(googleMatch.group(1)!);
                                         longitude = double.parse(googleMatch.group(2)!);
                                         parsed = true;
                                       } catch (_) {}
                                     }

                                     if (!parsed) {
                                       final RegExp osmRegExp = RegExp(r'#map=\d+(?:\.\d+)?/(-?\d+(?:\.\d+)?)/(-?\d+(?:\.\d+)?)');
                                       final osmMatch = osmRegExp.firstMatch(message.text);
                                       if (osmMatch != null && osmMatch.groupCount >= 2) {
                                         try {
                                           latitude = double.parse(osmMatch.group(1)!);
                                           longitude = double.parse(osmMatch.group(2)!);
                                           parsed = true;
                                         } catch (_) {}
                                       }
                                     }

                                     if (!parsed) {
                                       final parts = message.text.split(RegExp(r'[\s,/\n?&=]'));
                                       for (int i = 0; i < parts.length - 1; i++) {
                                         final latVal = double.tryParse(parts[i]);
                                         final lngVal = double.tryParse(parts[i+1]);
                                         if (latVal != null && lngVal != null && latVal >= -90 && latVal <= 90 && lngVal >= -180 && lngVal <= 180) {
                                           latitude = latVal;
                                           longitude = lngVal;
                                           parsed = true;
                                           break;
                                         }
                                       }
                                     }

                                     Get.toNamed(
                                       AppRoutes.locationMap,
                                       arguments: {
                                         'latitude': latitude,
                                         'longitude': longitude,
                                         'title': message.isSent ? 'Your Shared Location' : 'Contact\'s Shared Location',
                                       },
                                     );
                                   }
                                 },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isSent ? _primary : Colors.white,
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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (message.repliedToText != null) ...[
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(8),
                                              margin: const EdgeInsets.only(bottom: 8),
                                              decoration: BoxDecoration(
                                                color: isSent ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.05),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border(
                                                  left: BorderSide(
                                                    color: isSent ? Colors.white : _primary,
                                                    width: 3,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    message.repliedToSender ?? '',
                                                    style: TextStyle(
                                                      color: isSent ? Colors.white : _primary,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    message.repliedToText!,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: isSent ? Colors.white70 : const Color(0xFF4B5563),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          Text(
                                            message.text,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isSent
                                                  ? Colors.white
                                                  : const Color(0xFF111827),
                                              height: 1.45,
                                              decoration: (message.text.contains('📍') || message.text.contains('openstreetmap.org') || message.text.contains('maps.google.com'))
                                                  ? TextDecoration.underline
                                                  : null,
                                              decorationColor: isSent ? Colors.white70 : const Color(0xFF2046E8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (message.reaction != null)
                                      _buildReactionBadge(context, message.reaction, isSent),
                                  ],
                                ),
                              ),
                              if (isLastOfGroup)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, left: 4, right: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isSent
                                            ? 'Read ${message.time}'
                                            : message.time,
                                        style:
                                            TextStyle(fontSize: 11, color: _timeColor),
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

class VoiceBubble extends StatefulWidget {
  const VoiceBubble({
    super.key,
    required this.message,
    required this.isLastOfGroup,
    required this.messageIndex,
  });

  final ChatDetailMessage message;
  final bool isLastOfGroup;
  final int messageIndex;

  @override
  State<VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<VoiceBubble> {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  StreamSubscription? _stateSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _completeSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    if (widget.message.voiceDuration != null) {
      _duration = Duration(seconds: widget.message.voiceDuration!);
    }

    _stateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _completeSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _position = Duration.zero;
          _playerState = PlayerState.stopped;
        });
      }
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _completeSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    final path = widget.message.voicePath;
    if (path == null || path.isEmpty) return;

    if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(path));
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isSent = widget.message.isSent;
    final Color bubbleColor = isSent ? const Color(0xFF2046E8) : Colors.white;
    final Color subColor = isSent ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF6B7280);
    final Color sliderActive = isSent ? Colors.white : const Color(0xFF2046E8);
    final Color sliderInactive = isSent ? Colors.white.withValues(alpha: 0.3) : const Color(0xFFE5E7EB);

    final bool isPlaying = _playerState == PlayerState.playing;

    return Column(
      crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onLongPress: () => _showReactionDialog(context, widget.messageIndex, widget.message),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 220,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isSent ? 18 : 4),
                    bottomRight: Radius.circular(isSent ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _playPause,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSent ? Colors.white.withValues(alpha: 0.2) : const Color(0xFF2046E8).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: isSent ? Colors.white : const Color(0xFF2046E8),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 2,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                              activeTrackColor: sliderActive,
                              inactiveTrackColor: sliderInactive,
                              thumbColor: sliderActive,
                              overlayColor: sliderActive.withValues(alpha: 0.2),
                            ),
                            child: Slider(
                              value: _position.inMilliseconds.toDouble().clamp(
                                    0.0,
                                    _duration.inMilliseconds.toDouble(),
                                  ),
                              max: _duration.inMilliseconds > 0
                                  ? _duration.inMilliseconds.toDouble()
                                  : 1.0,
                              onChanged: (value) async {
                                final newPosition = Duration(milliseconds: value.toInt());
                                await _audioPlayer.seek(newPosition);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_position),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: subColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_duration),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: subColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.message.reaction != null)
                _buildReactionBadge(context, widget.message.reaction, isSent),
            ],
          ),
        ),
        if (widget.isLastOfGroup)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isSent
                      ? 'Read ${widget.message.time}'
                      : widget.message.time,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                ),
                if (isSent && widget.message.isRead) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all_rounded, size: 14, color: Color(0xFF2046E8)),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class ImageBubble extends StatelessWidget {
  const ImageBubble({
    super.key,
    required this.message,
    required this.isLastOfGroup,
    required this.messageIndex,
  });

  final ChatDetailMessage message;
  final bool isLastOfGroup;
  final int messageIndex;

  @override
  Widget build(BuildContext context) {
    final bool isSent = message.isSent;

    Widget buildImageWidget() {
      final path = message.imagePath ?? '';
      if (path.startsWith('http') || path.startsWith('https')) {
        return Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
          ),
        );
      } else if (path.isNotEmpty) {
        return Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
          ),
        );
      }
      return const Center(
        child: Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
      );
    }

    return GestureDetector(
      onLongPress: () => _showReactionDialog(context, messageIndex, message),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
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
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isSent ? 18 : 4),
                    bottomRight: Radius.circular(isSent ? 4 : 18),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 230,
                      maxHeight: 300,
                    ),
                    width: double.infinity,
                    child: buildImageWidget(),
                  ),
                ),
                if (isLastOfGroup)
                  Positioned(
                    bottom: 6,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isSent ? 'Read ${message.time}' : message.time,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isSent && message.isRead) ...[
                            const SizedBox(width: 3),
                            const Icon(Icons.done_all_rounded,
                                size: 13, color: Colors.lightBlueAccent),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (message.reaction != null)
            _buildReactionBadge(context, message.reaction, isSent),
        ],
      ),
    );
  }
}

class FileBubble extends StatelessWidget {
  const FileBubble({
    super.key,
    required this.message,
    required this.isLastOfGroup,
    required this.messageIndex,
  });

  final ChatDetailMessage message;
  final bool isLastOfGroup;
  final int messageIndex;

  @override
  Widget build(BuildContext context) {
    final bool isSent = message.isSent;
    final Color bubbleColor = isSent ? const Color(0xFF2046E8) : Colors.white;
    final Color textColor = isSent ? Colors.white : const Color(0xFF111827);
    final Color subColor = isSent ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF6B7280);
    final Color iconBgColor = isSent 
        ? Colors.white.withValues(alpha: 0.15) 
        : const Color(0xFF2046E8).withValues(alpha: 0.1);
    final Color iconColor = isSent ? Colors.white : const Color(0xFF2046E8);

    return Column(
      crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onLongPress: () => _showReactionDialog(context, messageIndex, message),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 240,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isSent ? 18 : 4),
                    bottomRight: Radius.circular(isSent ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.description_rounded,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.fileName ?? message.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            message.fileSize ?? '',
                            style: TextStyle(
                              color: subColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (message.reaction != null)
                _buildReactionBadge(context, message.reaction, isSent),
            ],
          ),
        ),
        if (isLastOfGroup)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isSent ? 'Read ${message.time}' : message.time,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                ),
                if (isSent && message.isRead) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all_rounded, size: 14, color: Color(0xFF2046E8)),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
