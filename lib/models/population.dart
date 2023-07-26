import 'package:equatable/equatable.dart';
import 'package:genetic_evolution/models/entity.dart';

class Population<T> extends Equatable {
  const Population({
    required this.entities,
  });

  /// Represents the entities present within this population.
  final List<Entity<T>> entities;
  @override
  List<Object?> get props => [
        entities,
      ];
}

extension PopulationExtension<T> on Population<T> {
  /// Returns a list of entities in this population sorted in order from highest
  /// fitnessScore to lowest.
  List<Entity<T>> get sortedEntities => entities
    ..sort(
      (a, b) => b.fitnessScore.compareTo(a.fitnessScore),
    );

  /// Returns the top scoring entity from this population.
  Entity<T> get topScoringEntity => sortedEntities.first;
}
