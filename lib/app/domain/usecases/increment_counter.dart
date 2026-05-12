import '../entities/counter.dart';
import '../repositories/counter_repository.dart';

class IncrementCounter {
  const IncrementCounter(this._repository);

  final CounterRepository _repository;

  Counter call(Counter counter) {
    return _repository.increment(counter);
  }
}
