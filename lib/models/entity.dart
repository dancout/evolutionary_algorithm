part of 'package:genetic_evolution/genetic_evolution.dart';

/// Represents a single Entity within a larger Population.
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

  /// Represents the parents of this entity.
  final List<Entity<T>>? parents;

  @override
  List<Object?> get props => [
        dna,
        fitnessScore,
        parents,
      ];
}
