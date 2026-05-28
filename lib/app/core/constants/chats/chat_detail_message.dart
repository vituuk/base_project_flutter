/// Model representing a single message in the chat detail screen.
class ChatDetailMessage {
  final String text;
  final bool isSent;
  final String time;
  final bool isRead;
  final bool isCallLog;
  final String? callType; // "missed", "outgoing", "canceled"
  final String? callDuration;
  final bool isVoice;
  final String? voicePath;
  final int? voiceDuration; // in seconds
  final bool isImage;
  final String? imagePath;
  final bool isFile;
  final String? fileName;
  final String? fileSize;

  const ChatDetailMessage({
    required this.text,
    required this.isSent,
    required this.time,
    this.isRead = false,
    this.isCallLog = false,
    this.callType,
    this.callDuration,
    this.isVoice = false,
    this.voicePath,
    this.voiceDuration,
    this.isImage = false,
    this.imagePath,
    this.isFile = false,
    this.fileName,
    this.fileSize,
  });
}

/// Static seed data for the chat detail / conversation screen.
const List<ChatDetailMessage> kChatDetailMessages = [
  ChatDetailMessage(
    text: "Hello! I've reviewed the quarterly performance metrics we discussed this morning.",
    isSent: false,
    time: '4:32 PM',
  ),
  ChatDetailMessage(
    text: "Missed Call",
    isSent: false,
    time: '11:20 AM',
    isCallLog: true,
    callType: 'missed',
  ),
  ChatDetailMessage(
    text: "Outgoing Call",
    isSent: true,
    time: '11:20 AM',
    isCallLog: true,
    callType: 'outgoing',
    callDuration: '2 min 49sec',
  ),
  ChatDetailMessage(
    text: "Canceled Call",
    isSent: true,
    time: '11:20 AM',
    isCallLog: true,
    callType: 'canceled',
  ),
  ChatDetailMessage(
    text: "The conversion rate for the enterprise segment is up by 12%. Should we finalize the slide deck for tomorrow's board meeting?",
    isSent: false,
    time: '4:34 PM',
  ),
  ChatDetailMessage(
    text: "That's great news about the enterprise segment! I think we should definitely highlight that in the executive summary.",
    isSent: true,
    time: '4:45 PM',
    isRead: true,
  ),
  ChatDetailMessage(
    text: "I've added the updated charts to the shared folder. Take a look and let me know if they align with your findings.",
    isSent: true,
    time: '4:45 PM',
    isRead: true,
  ),
];
