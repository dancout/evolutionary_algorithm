import 'package:equatable/equatable.dart';
import 'package:genetic_evolution/models/dna.dart';

class Entity<T> extends Equatable {
  const Entity({
    required this.dna,
    required this.fitnessScore,
    this.parents,
  });

  /// Represents the DNA makeup of this Entity.
  final DNA<T> dna;

  /// Represents the fitness score for this Entity.
  final double fitnessScore;

  // TODO: Add this into the mix as an optional thing so we can keep track of this
  /// entity's parents.
  final List<Entity<T>>? parents;

  @override
  List<Object?> get props => [
        dna,
        fitnessScore,
        parents,
      ];
}
