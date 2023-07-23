import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class Gene<T> extends Equatable {
  Gene({
    double mutationRate = 0,
    required T value,
  }) {
    assert(
      mutationRate >= 0.toDouble() && mutationRate <= 1.toDouble(),
      'mutationRate must be between 0 and 1, inclusively',
    );

    final randomValue = Random().nextDouble();

    if (mutationRate > randomValue) {
      this.value = mutate();
    } else {
      this.value = value;
    }
  }

  late final T value;

  T mutate();

  @override
  List<Object?> get props => [
        value,
      ];
}
