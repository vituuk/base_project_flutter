import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/profiles/profile_file_item.dart';
import '../../../core/constants/profiles/profile_link_item.dart';
import '../../../core/constants/profiles/profile_media_item.dart';
import '../../../core/constants/profiles/profile_voice_item.dart';
import '../controllers/profile_controller.dart';
import 'files_list.dart';
import 'links_list.dart';
import 'media_grid.dart';
import 'tab_item.dart';
import 'voice_list.dart';

class MediaTabsSection extends StatelessWidget {
  final ProfileController controller;

  const MediaTabsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Headers with horizontal padding
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              final activeTab = controller.selectedTab.value;
              return Row(
                children: [
                  TabItem(
                    label: 'Media',
                    isActive: activeTab == 'Media',
                    onTap: () => controller.selectedTab.value = 'Media',
                  ),
                  TabItem(
                    label: 'Files',
                    isActive: activeTab == 'Files',
                    onTap: () => controller.selectedTab.value = 'Files',
                  ),
                  TabItem(
                    label: 'Links',
                    isActive: activeTab == 'Links',
                    onTap: () => controller.selectedTab.value = 'Links',
                  ),
                  TabItem(
                    label: 'Voice',
                    isActive: activeTab == 'Voice',
                    onTap: () => controller.selectedTab.value = 'Voice',
                  ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        // Tab Content
        Obx(() {
          final activeTab = controller.selectedTab.value;
          if (activeTab == 'Media') {
            return const MediaGrid(mediaItems: kProfileMediaItems);
          } else if (activeTab == 'Files') {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: FilesList(fileItems: kProfileFileItems),
            );
          } else if (activeTab == 'Links') {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinksList(linkItems: kProfileLinkItems),
            );
          } else if (activeTab == 'Voice') {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: VoiceList(voiceItems: kProfileVoiceItems),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
}
