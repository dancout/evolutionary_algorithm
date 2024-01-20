part of 'package:genetic_evolution/genetic_evolution.dart';

/// Represents a collection of [Entity] objects.
class Population<T> extends Equatable {
  /// Represents a collection of [Entity] objects.
  const Population({
    required this.entities,
    this.sortingMethod = _fallbackSortMethod,
  });

  /// Represents the entities present within this population.
  final List<Entity<T>> entities;

  /// The method used to sort [entites].
  final int Function(Entity<T> a, Entity<T> b)? sortingMethod;

  /// Sorts [Entity] objects in order from highest fitness score to lowest.
  static int _fallbackSortMethod(Entity a, Entity b) =>
      b.fitnessScore.compareTo(a.fitnessScore);

  /// Returns a sorted list of [entities] in this population.
  List<Entity<T>> get sortedEntities =>
      List.from(entities)..sort(sortingMethod);

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
