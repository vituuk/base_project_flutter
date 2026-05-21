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
    avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    unreadCount: 0,
    isOnline: true,
  ),
  ChatListItem(
    name: 'Alex Rivera',
    lastMessage: 'Hey, did you see the new proposal for the Blue Horizon project?',
    time: '2m ago',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    unreadCount: 2,
    isOnline: true,
  ),
  ChatListItem(
    name: 'Mike',
    lastMessage: 'Check out the latest UI kit updates I pushed to the repository.',
    time: '1h ago',
    avatarUrl: 'https://randomuser.me/api/portraits/men/75.jpg',
    unreadCount: 0,
    isOnline: false,
  ),
  ChatListItem(
    name: 'Football',
    lastMessage: 'Do you guys want to play tomorrow?',
    time: 'Yesterday',
    avatarUrl: 'https://randomuser.me/api/portraits/lego/1.jpg',
    unreadCount: 0,
    isOnline: false,
  ),
  ChatListItem(
    name: 'Elena',
    lastMessage: 'The client was really impressed with the presentation today.',
    time: 'Yesterday',
    avatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
    unreadCount: 0,
    isOnline: true,
  ),
  ChatListItem(
    name: 'Talena',
    lastMessage: 'The client was really impressed with the presentation today.',
    time: 'Yesterday',
    avatarUrl: 'https://randomuser.me/api/portraits/women/85.jpg',
    unreadCount: 0,
    isOnline: false,
  ),
  ChatListItem(
    name: 'John',
    lastMessage: 'Let play something.',
    time: 'Yesterday',
    avatarUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
    unreadCount: 0,
    isOnline: false,
  ),
  ChatListItem(
    name: 'Kana',
    lastMessage: 'Hello',
    time: 'Yesterday',
    avatarUrl: 'https://randomuser.me/api/portraits/women/90.jpg',
    unreadCount: 0,
    isOnline: false,
  ),
];
