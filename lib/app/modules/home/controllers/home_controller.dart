import 'package:get/get.dart';

import '../../../core/constants/chats/chat_list_item.dart';
import '../../../domain/entities/counter.dart';
import '../../../domain/entities/todo.dart';
import '../../../domain/usecases/get_todo.dart';
import '../../../domain/usecases/increment_counter.dart';
import '../../../routes/app_routes.dart';

export '../../../core/constants/chats/chat_list_item.dart' show ChatListItem;

class HomeController extends GetxController {
  HomeController({
    required IncrementCounter incrementCounter,
    required GetTodo getTodo,
  }) : _incrementCounter = incrementCounter,
       _getTodo = getTodo;

  final IncrementCounter _incrementCounter;
  final GetTodo _getTodo;
  final _counter = const Counter(0).obs;
  final _todo = Rxn<Todo>();
  final _isLoadingTodo = false.obs;
  final _todoError = RxnString();
  final _age = 0.obs;

  int get count => _counter.value.value;
  Todo? get todo => _todo.value;
  bool get isLoadingTodo => _isLoadingTodo.value;
  String? get todoError => _todoError.value;
  int? get age => _age.value;

  void increment() {
    _counter.value = _incrementCounter(_counter.value);
  }

  void decrement() {
    _counter.value = Counter(_counter.value.value - 1);
  }

  void sum() {
    _counter.value = Counter(_counter.value.value + 1);
  }

  Future<void> loadTodo() async {
    _isLoadingTodo.value = true;
    _todoError.value = null;

    try {
      _todo.value = await _getTodo();
    } catch (error) {
      _todoError.value = error.toString();
    } finally {
      _isLoadingTodo.value = false;
    }
  }
}

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

class ListMenuController extends GetxController {
  final count = 0.obs;

  void increaseCounter() {
    count.value++;
  }
}

class MenuBarController extends GetxController {
  final activeRoute = ''.obs;

  @override
  void onInit() {
    super.onInit();
    activeRoute.value = Get.currentRoute;
  }

  void navigateTo(String route) {
    activeRoute.value = route;
    Get.toNamed(route);
  }

  final menuItems = <Map<String, dynamic>>[
    {'label': 'Home', 'route': AppRoutes.home},
    {'label': 'Detail', 'route': AppRoutes.detail},
    {'label': 'User', 'route': AppRoutes.user},
    {'label': 'Chat', 'route': AppRoutes.chat},
  ];
}
