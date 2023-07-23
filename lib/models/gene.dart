import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class Gene<T> extends Equatable {
  Gene({
    /// The intended encoded value for this Gene.
    required T value,

    /// A value between 0 and 1, inclusively, that represents if this gene
    /// should mutate its value. A value of 0 will never mutate and a value of 1
    /// will always mutate.
    double mutationRate = 0,

    /// This value will be used to check against the mutationRate to determine
    /// if the gene should be mutated.
    @visibleForTesting double? randomValue,
  }) {
    assert(
      mutationRate >= 0.toDouble() && mutationRate <= 1.toDouble(),
      'mutationRate must be between 0 and 1, inclusively',
    );

    final randValue = randomValue ?? Random().nextDouble();

    if (mutationRate > randValue) {
      this.value = mutate();
    } else {
      this.value = value;
    }
  }

  /// The encoded value for this gene.
  late final T value;

  /// Returns a mutated encoded value of type <T>.
  T mutate();

  @override
  List<Object?> get props => [
        value,
      ];
}
