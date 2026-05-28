import 'package:flutter/material.dart';
import '../../../core/constants/profiles/profile_file_item.dart';
import '../../../core/theme/theme_extensions.dart';
import 'info_card.dart';

class FilesList extends StatelessWidget {
  final List<ProfileFileItem> fileItems;

  const FilesList({
    super.key,
    required this.fileItems,
  });

  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fileItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = fileItems[index];
        return InfoCard(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.fileName,
                        style: TextStyle(
                          color: _darkText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.fileSize} • ${item.fileDate}',
                        style: TextStyle(
                          color: _subtitleColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.file_download_outlined, color: Color(0xFF6B7280), size: 22),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
