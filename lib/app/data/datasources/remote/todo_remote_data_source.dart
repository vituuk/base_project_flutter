import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<TodoModel> getTodo();
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  const TodoRemoteDataSourceImpl(this._client);

  final DioClient _client;

  @override
  Future<TodoModel> getTodo() async {
    final response = await _client.get<Map<String, dynamic>>(ApiEndpoints.todo);
    final data = response.data;

    if (data == null) {
      throw const ApiException('The server returned an empty response.');
    }

    return TodoModel.fromJson(data);
  }
}
