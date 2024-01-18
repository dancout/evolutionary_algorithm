part of 'package:genetic_evolution/genetic_evolution.dart';

/// Represents a collection of [Entity] objects.
class Population<T> extends Equatable {
  /// Represents a collection of [Entity] objects.
  Population({
    required this.entities,
    int Function(Entity<T> a, Entity<T> b)? sortingMethod,
  }) {
    fallbackSortMethod(Entity<T> a, Entity<T> b) =>
        b.fitnessScore.compareTo(a.fitnessScore);

    this.sortingMethod = sortingMethod ?? fallbackSortMethod;
  }

  /// Represents the entities present within this population.
  final List<Entity<T>> entities;

  /// Represents the method used to sort [Population.entities].
  late final int Function(Entity<T> a, Entity<T> b) sortingMethod;

  /// Returns a list of entities in this population sorted in order from highest
  /// fitnessScore to lowest.
  List<Entity<T>> get sortedEntities => List.from(entities)
    ..sort(
      sortingMethod,
    );

  /// Returns the top scoring entity from this population.
  Entity<T> get topScoringEntity {
    return entities.fold(
      entities.first,
      (previousValue, element) =>
          element.fitnessScore > previousValue.fitnessScore
              ? element
              : previousValue,
    );
  }

  @override
  List<Object?> get props => [
        entities,
        sortingMethod,
      ];
}
