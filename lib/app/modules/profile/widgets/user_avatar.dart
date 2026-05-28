import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String url;
  final double? errorIconSize;

  const UserAvatar({
    super.key,
    required this.url,
    this.errorIconSize,
  });

  static const Color _primary = Color(0xFF2046E8);

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFFDDE6F9),
          child: Icon(Icons.person_rounded, color: _primary, size: errorIconSize ?? 24),
        ),
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFFDDE6F9),
          child: Icon(Icons.person_rounded, color: _primary, size: errorIconSize ?? 24),
        ),
      );
    }
  }
}
