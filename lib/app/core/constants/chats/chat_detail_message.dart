/// Model representing a single message in the chat detail screen.
class ChatDetailMessage {
  final String text;
  final bool isSent;
  final String time;
  final bool isRead;

  const ChatDetailMessage({
    required this.text,
    required this.isSent,
    required this.time,
    this.isRead = false,
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
