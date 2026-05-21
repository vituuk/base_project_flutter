import 'package:get/get.dart';

import '../../../domain/entities/counter.dart';
import '../../../domain/entities/todo.dart';
import '../../../domain/usecases/get_todo.dart';
import '../../../domain/usecases/increment_counter.dart';

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
