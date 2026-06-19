/// Model representing a single contact entry.
class ContactItem {
  final String name;
  final String status;
  final String? avatarUrl;
  final bool isOnline;

  const ContactItem({
    required this.name,
    required this.status,
    this.avatarUrl,
    this.isOnline = false,
  });

  /// First character of name, uppercased – used to group contacts alphabetically.
  String get groupKey =>
      name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '#';

  /// Initials (up to 2 characters) used when no [avatarUrl] is provided.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

/// Static seed data for the contacts screen.
const List<ContactItem> kContactItems = [
  ContactItem(
    name: 'Alex Rivera',
    status: 'Active now',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    isOnline: true,
  ),
  ContactItem(
    name: 'Alice Johnson',
    status: 'Last seen within a week',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    isOnline: false,
  ),
  ContactItem(
    name: 'Benjamin Walker',
    status: 'Last seen 3h ago',
    avatarUrl: null, // will show initials "BW"
    isOnline: false,
  ),
  ContactItem(
    name: 'Chris Miller',
    status: 'Last seen 2h ago',
    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    isOnline: false,
  ),
  ContactItem(
    name: 'Diana Prince',
    status: 'Active now',
    avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    isOnline: true,
  ),
  ContactItem(
    name: 'Edward Chen',
    status: 'Last seen yesterday',
    avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
    isOnline: false,
  ),
  ContactItem(
    name: 'Fiona Green',
    status: 'Active now',
    avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
    isOnline: true,
  ),
];
