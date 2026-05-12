import '../entities/counter.dart';

abstract class CounterRepository {
  Counter increment(Counter counter);
}
