import 'package:flutter/material.dart';
import '../../../core/constants/profiles/profile_link_item.dart';
import '../../../core/theme/theme_extensions.dart';
import 'info_card.dart';

class LinksList extends StatelessWidget {
  final List<ProfileLinkItem> linkItems;

  const LinksList({
    super.key,
    required this.linkItems,
  });

  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: linkItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = linkItems[index];
        return InfoCard(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildLinkThumbnail(item.thumbnail),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          color: _darkText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.url,
                        style: const TextStyle(
                          color: Color(0xFF2046E8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.date,
                        style: TextStyle(
                          color: _subtitleColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_new_rounded, color: Color(0xFF6B7280), size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLinkThumbnail(ProfileLinkThumbnail t) {
    final decoration = t.gradientColors != null
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: t.gradientColors!.map((c) => Color(c)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          )
        : BoxDecoration(
            color: Color(t.solidColor!),
            borderRadius: BorderRadius.circular(12),
          );
    return Container(
      width: 48,
      height: 48,
      decoration: decoration,
      child: Icon(
        t.iconData,
        color: Color(t.iconColor),
        size: 22,
      ),
    );
  }
}
