import '../entities/todo.dart';

abstract class TodoRepository {
  Future<Todo> getTodo();
}
