import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/remote/todo_remote_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl(this._remoteDataSource);

  final TodoRemoteDataSource _remoteDataSource;

  @override
  Future<Todo> getTodo() {
    return _remoteDataSource.getTodo();
  }
}
