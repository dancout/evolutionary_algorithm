import 'package:evolutionary_algorithm/models/population.dart';

class Generation {
  const Generation({
    required this.wave,
    required this.population,
  });

  /// Represents this Generation's number. This is intended to increment by 1
  /// after each population continues to reproduce.
  final int wave;

  /// Represents the Popoulation of Entities within this Generation.
  final Population population;
}
