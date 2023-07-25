import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:genetic_evolution/models/gene.dart';

abstract class GeneService<T> {
  GeneService({
    required this.mutationRate,
    Random? random,
  }) {
    assert(
      mutationRate >= 0.toDouble() && mutationRate <= 1.toDouble(),
      'mutationRate must be between 0 and 1, inclusively',
    );

    this.random = random ?? Random();
  }

  /// A value between 0 and 1, inclusively, that represents if this gene
  /// should mutate its value. A value of 0 will never mutate and a value of 1
  /// will always mutate.
  final double mutationRate;

  /// Used as the internal random number generator.
  late final Random random;

  /// Returns a randomly initialized Gene of type <T>.
  Gene<T> randomGene();

  /// Returns a mutated encoded value of type <T>.
  @visibleForTesting
  T mutateValue({T? value});

  /// This function will return a Gene of type <T> that may have been mutated
  /// based on the mutationRate of this class.
  Gene<T> mutateGene({
    /// The base Gene to be potentially mutated against.
    required Gene<T> gene,
  }) {
    // Declare the value of type <T> to be passed forward.
    late final T value;

    // Generate a random value between 0 and 1.
    final randomValue = random.nextDouble();

    // Check if we should mutate this
    if (mutationRate > randomValue) {
      // Mutate the value.
      value = this.mutateValue(value: gene.value);
    } else {
      // Pass the same value forward.
      value = gene.value;
    }

    return Gene<T>(value: value);
  }
}
