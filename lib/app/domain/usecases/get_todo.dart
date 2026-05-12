import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodo {
  const GetTodo(this._repository);

  final TodoRepository _repository;

  Future<Todo> call() {
    return _repository.getTodo();
  }
}
