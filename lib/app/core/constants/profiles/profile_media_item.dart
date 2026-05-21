/// Model and seed data for the Media tab grid on the profile page.
class ProfileMediaItem {
  final String imageUrl;
  final String? duration;

  const ProfileMediaItem({required this.imageUrl, this.duration});
}

const List<ProfileMediaItem> kProfileMediaItems = [
  ProfileMediaItem(
    imageUrl: 'https://images.unsplash.com/photo-1556881286-fc6915169721?auto=format&fit=crop&q=80&w=300',
  ),
  ProfileMediaItem(
    imageUrl: 'https://images.unsplash.com/photo-1547082299-de196ea013d6?auto=format&fit=crop&q=80&w=300',
  ),
  ProfileMediaItem(
    imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&q=80&w=300',
    duration: '1:05',
  ),
  ProfileMediaItem(
    imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=300',
  ),
  ProfileMediaItem(
    imageUrl: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&q=80&w=300',
  ),
  ProfileMediaItem(
    imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&q=80&w=300',
    duration: '24:20',
  ),
  ProfileMediaItem(
    imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&q=80&w=300',
  ),
  ProfileMediaItem(
    imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&q=80&w=300',
  ),
  ProfileMediaItem(
    imageUrl: 'https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&q=80&w=300',
  ),
];
