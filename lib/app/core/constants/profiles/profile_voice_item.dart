/// Model and seed data for the Voice tab on the profile page.
class ProfileVoiceItem {
  final String duration;
  final String date;
  final List<double> waveform;

  const ProfileVoiceItem({
    required this.duration,
    required this.date,
    required this.waveform,
  });
}

const List<ProfileVoiceItem> kProfileVoiceItems = [
  ProfileVoiceItem(
    duration: '0:45',
    date: 'Shared Oct 12, 2023',
    waveform: [8, 14, 20, 24, 18, 12, 16, 22, 14, 8, 12, 18, 10, 6],
  ),
  ProfileVoiceItem(
    duration: '0:12',
    date: 'Shared Oct 12, 2023',
    waveform: [10, 16, 24, 18, 12, 14, 20, 16, 10, 8, 14, 12, 6],
  ),
];
