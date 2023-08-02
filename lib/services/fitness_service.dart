import 'package:flutter/foundation.dart';
import 'package:genetic_evolution/models/dna.dart';

/// Used for calculating the fitness score on a given strand of DNA.
abstract class FitnessService<T> {
  /// Returns the fitnessScore calculated on the input [dna].
  Future<double> calculateScore({required DNA<T> dna}) async {
    // In the event that all entities in a population return a fitnessScore of
    // 0, no parents can be selected for the next population. For this purpose,
    // add a value to each score so that there are no 0 values.
    return (await scoringFunction(dna: dna)) + nonZeroBias;
  }

  /// The internal scoring function that will calculate this DNA's fitnessScore.
  @visibleForTesting
  Future<double> scoringFunction({required DNA<T> dna});

  /// Added to each fitnessScore.
  ///
  /// The intention is to avoid any 0 values. If your fitness function accounts
  /// for this scenario, or negative or 0 values are acceptable, mark this
  /// value as 0.
  @visibleForTesting
  double get nonZeroBias;
}
