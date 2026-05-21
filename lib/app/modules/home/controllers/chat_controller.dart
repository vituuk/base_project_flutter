import 'package:get/get.dart';

import '../../../core/constants/chats/chat_list_item.dart';
export '../../../core/constants/chats/chat_list_item.dart' show ChatListItem;

class ChatController extends GetxController {
  final searchQuery = ''.obs;

  final _messages = <ChatListItem>[...kChatListItems].obs;

  List<ChatListItem> get filteredMessages {
    if (searchQuery.value.isEmpty) return _messages;
    return _messages
        .where((m) =>
            m.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            m.lastMessage
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }
}
