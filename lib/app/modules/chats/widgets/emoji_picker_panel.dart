import 'package:flutter/material.dart';
import '../../../core/constants/emojis.dart';
import '../../../core/theme/theme_extensions.dart';
import '../controllers/chat_detail_controller.dart';

class EmojiPickerPanel extends StatefulWidget {
  const EmojiPickerPanel({super.key, required this.controller});
  final ChatDetailController controller;

  @override
  State<EmojiPickerPanel> createState() => _EmojiPickerPanelState();
}

class _EmojiPickerPanelState extends State<EmojiPickerPanel> {
  int _selectedCategoryIndex = 0;
  late PageController _pageController;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Smileys & People', 'icon': '😊'},
    {'name': 'Animals & Nature', 'icon': '🐱'},
    {'name': 'Food & Drink', 'icon': '🍔'},
    {'name': 'Activity & Sports', 'icon': '⚽'},
    {'name': 'Travel & Places', 'icon': '🚗'},
    {'name': 'Objects & Symbols', 'icon': '💡'},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = 280;
    final Color categoryBg = AppColors.bg;
    final Color dividerColor = AppColors.divider;

    return Container(
      height: keyboardHeight,
      color: AppColors.card,
      child: Column(
        children: [
          Container(height: 1, color: dividerColor),
          Container(
            height: 48,
            color: categoryBg,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () => _onCategorySelected(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                          ),
                          child: Text(
                            cat['icon'] as String,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: widget.controller.deleteEmoji,
                    icon: Icon(
                      Icons.backspace_outlined,
                      color: AppColors.subtitle,
                      size: 20,
                    ),
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              itemCount: _categories.length,
              itemBuilder: (context, catIndex) {
                final categoryName = _categories[catIndex]['name'] as String;
                final emojis = kEmojiCategories[categoryName] ?? [];
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: emojis.length,
                  itemBuilder: (context, emojiIndex) {
                    final emoji = emojis[emojiIndex];
                    return EmojiCell(
                      emoji: emoji,
                      onTap: () => widget.controller.insertEmoji(emoji),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EmojiCell extends StatefulWidget {
  const EmojiCell({super.key, required this.emoji, required this.onTap});
  final String emoji;
  final VoidCallback onTap;

  @override
  State<EmojiCell> createState() => _EmojiCellState();
}

class _EmojiCellState extends State<EmojiCell> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = 0.85;
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _scale = 1.0;
        });
      },
      child: Transform.scale(
        scale: _scale,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            widget.emoji,
            style: const TextStyle(fontSize: 26),
          ),
        ),
      ),
    );
  }
}
