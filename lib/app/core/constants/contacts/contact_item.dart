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
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    isOnline: true,
  ),
  ContactItem(
    name: 'Alice Johnson',
    status: 'Last seen within a week',
    avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
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
    avatarUrl: 'https://randomuser.me/api/portraits/men/75.jpg',
    isOnline: false,
  ),
  ContactItem(
    name: 'Diana Prince',
    status: 'Active now',
    avatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
    isOnline: true,
  ),
  ContactItem(
    name: 'Edward Chen',
    status: 'Last seen yesterday',
    avatarUrl: 'https://randomuser.me/api/portraits/men/46.jpg',
    isOnline: false,
  ),
  ContactItem(
    name: 'Fiona Green',
    status: 'Active now',
    avatarUrl: 'https://randomuser.me/api/portraits/women/85.jpg',
    isOnline: true,
  ),
];
