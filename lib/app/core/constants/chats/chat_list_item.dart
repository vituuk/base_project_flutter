/// Model representing a single chat entry in the chat list.
class ChatListItem {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;
  final bool isOnline;

  const ChatListItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

/// Static seed data for the chat list screen.
const List<ChatListItem> kChatListItems = [
  ChatListItem(
    name: 'Sarah',
    lastMessage: "That sounds like a great plan! Let's sync at 3 PM tomorrow.",
    time: '45m ago',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    unreadCount: 0,
    isOnline: true,
  ),
  ChatListItem(
    name: 'Alex Rivera',
    lastMessage: 'Hey, did you see the new proposal for the Blue Horizon project?',
    time: '2m ago',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    unreadCount: 2,
    isOnline: true,
  ),
  ChatListItem(
    name: 'Mike',
    lastMessage: 'Check out the latest UI kit updates I pushed to the repository.',
    time: '1h ago',
    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    unreadCount: 0,
    isOnline: false,
  ),
  ChatListItem(
    name: 'Football',
    lastMessage: 'Do you guys want to play tomorrow?',
    time: 'Yesterday',
    avatarUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=150',
    unreadCount: 0,
    isOnline: false,
  ),
  ChatListItem(
    name: 'Elena',
    lastMessage: 'The client was really impressed with the presentation today.',
    time: 'Yesterday',
    avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    unreadCount: 0,
    isOnline: true,
  ),
  ChatListItem(
    name: 'Talena',
    lastMessage: 'The client was really impressed with the presentation today.',
    time: 'Yesterday',
    avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
    unreadCount: 0,
    isOnline: false,
  ),
  ChatListItem(
    name: 'John',
    lastMessage: 'Let play something.',
    time: 'Yesterday',
    avatarUrl: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150',
    unreadCount: 0,
    isOnline: false,
  ),
  ChatListItem(
    name: 'Kana',
    lastMessage: 'Hello',
    time: 'Yesterday',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    unreadCount: 0,
    isOnline: false,
  ),
];
