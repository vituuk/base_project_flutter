import '../../domain/entities/counter.dart';
import '../../domain/repositories/counter_repository.dart';

class CounterRepositoryImpl implements CounterRepository {
  @override
  Counter increment(Counter counter) {
    return counter.copyWith(value: counter.value + 1);
  }
}
