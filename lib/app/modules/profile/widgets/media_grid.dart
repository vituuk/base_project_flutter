import 'package:flutter/material.dart';
import '../../../core/constants/profiles/profile_media_item.dart';
import '../../../core/theme/theme_extensions.dart';

class MediaGrid extends StatelessWidget {
  final List<ProfileMediaItem> mediaItems;

  const MediaGrid({
    super.key,
    required this.mediaItems,
  });

  static Color get _subtitleColor => AppColors.subtitle;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mediaItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final item = mediaItems[index];
        return Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFD1D5DB),
                  child: Icon(Icons.image_outlined, color: _subtitleColor),
                ),
              ),
            ),
            if (item.duration != null)
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item.duration!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
