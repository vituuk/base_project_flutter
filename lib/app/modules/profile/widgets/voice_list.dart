import 'package:flutter/material.dart';
import '../../../core/constants/profiles/profile_voice_item.dart';
import '../../../core/theme/theme_extensions.dart';
import 'info_card.dart';

class VoiceList extends StatelessWidget {
  final List<ProfileVoiceItem> voiceItems;

  const VoiceList({
    super.key,
    required this.voiceItems,
  });

  static Color get _darkText => AppColors.text;
  static Color get _subtitleColor => AppColors.subtitle;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: voiceItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = voiceItems[index];
        return InfoCard(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Play Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2046E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildWaveform(item.waveform),
                          const Spacer(),
                          Text(
                            item.duration,
                            style: TextStyle(
                              color: _darkText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
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
                const SizedBox(width: 8),
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

  Widget _buildWaveform(List<double> heights) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: heights.asMap().entries.map((entry) {
        final index = entry.key;
        final height = entry.value;
        final isActive = index < 3;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 3,
          height: height,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2046E8) : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      }).toList(),
    );
  }
}
