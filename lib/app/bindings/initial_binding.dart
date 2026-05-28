import 'package:get/get.dart';

import '../core/network/dio_client.dart';
import '../data/datasources/remote/todo_remote_data_source.dart';
import '../data/repositories/counter_repository_impl.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../domain/repositories/counter_repository.dart';
import '../domain/repositories/todo_repository.dart';
import '../domain/usecases/get_todo.dart';
import '../domain/usecases/increment_counter.dart';
import '../modules/auth/controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(DioClient.new, fenix: true);
    Get.lazyPut<CounterRepository>(CounterRepositoryImpl.new, fenix: true);
    Get.lazyPut<TodoRemoteDataSource>(
      () => TodoRemoteDataSourceImpl(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<TodoRepository>(
      () => TodoRepositoryImpl(Get.find<TodoRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut(
      () => IncrementCounter(Get.find<CounterRepository>()),
      fenix: true,
    );
    Get.lazyPut(() => GetTodo(Get.find<TodoRepository>()), fenix: true);
    Get.lazyPut<WelcomeController>(() => WelcomeController(), fenix: true);
  }
}
