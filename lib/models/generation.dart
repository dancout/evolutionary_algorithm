import 'package:genetic_evolution/models/population.dart';

class Generation<T> {
  const Generation({
    required this.wave,
    required this.population,
  });

  /// Represents this Generation's number. This is intended to increment by 1
  /// after each population continues to reproduce.
  final int wave;

  /// Represents the Popoulation of Entities within this Generation.
  final Population<T> population;
}
