/// Model and seed data for the Links tab on the profile page.
class ProfileLinkItem {
  final String title;
  final String url;
  final String date;

  /// Thumbnail data — stored as plain data so the model stays widget-free.
  final ProfileLinkThumbnail thumbnail;

  const ProfileLinkItem({
    required this.title,
    required this.url,
    required this.date,
    required this.thumbnail,
  });
}

/// Describes how to render the link thumbnail.
class ProfileLinkThumbnail {
  /// Solid background colour (used when [gradientColors] is null).
  final int? solidColor;

  /// Two-stop gradient colours (used when [solidColor] is null).
  final List<int>? gradientColors;

  /// Icon codepoint from [Icons] (material icon).
  final int iconCodePoint;

  /// Icon colour.
  final int iconColor;

  const ProfileLinkThumbnail({
    this.solidColor,
    this.gradientColors,
    required this.iconCodePoint,
    required this.iconColor,
  });
}

const List<ProfileLinkItem> kProfileLinkItems = [
  ProfileLinkItem(
    title: 'Project Documentation',
    url: 'notion.so',
    date: 'Shared Oct 12, 2023',
    thumbnail: ProfileLinkThumbnail(
      solidColor: 0xFFF1F5F9,
      iconCodePoint: 0xe22b, // Icons.edit_note_rounded
      iconColor: 0xFFFFFFFF,
    ),
  ),
  ProfileLinkItem(
    title: 'Design Inspiration',
    url: 'dribbble.com',
    date: 'Shared Oct 10, 2023',
    thumbnail: ProfileLinkThumbnail(
      gradientColors: [0xFFEA4C89, 0xFFFF8AB3],
      iconCodePoint: 0xe40a, // Icons.palette_outlined
      iconColor: 0xFFFFFFFF,
    ),
  ),
  ProfileLinkItem(
    title: 'Meeting Recording',
    url: 'zoom.us',
    date: 'Shared Oct 08, 2023',
    thumbnail: ProfileLinkThumbnail(
      solidColor: 0xFF2D8CFF,
      iconCodePoint: 0xe63d, // Icons.videocam_rounded
      iconColor: 0xFFFFFFFF,
    ),
  ),
  ProfileLinkItem(
    title: 'Q4 Design Specs',
    url: 'figma.com',
    date: 'Shared Oct 05, 2023',
    thumbnail: ProfileLinkThumbnail(
      solidColor: 0xFF0F172A,
      iconCodePoint: 0xe3b1, // Icons.layers_outlined
      iconColor: 0xFF38BDF8,
    ),
  ),
];
