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
  @JsonKey(
    toJson: sortingMethodToJson,
    fromJson: sortingMethodFromJson,
  )
  final int Function(Entity a, Entity b)? sortingMethod;

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

  /// Converts the input [json] into a [Population] object.
  factory Population.fromJson(Map<String, dynamic> json) {
    return Population<T>(
      entities: (json['entities'] as List<dynamic>)
          .map((entityJson) => Entity<T>.fromJson(entityJson))
          .toList(),
    );
  }

  /// Converts the [Population] object to JSON.
  Map<String, dynamic> toJson() {
    return {
      'entities': entities.map((entity) => entity.toJson()).toList(),
      // TODO: Consider option for writing sortingMethod to and from JSON.
    };
  }

  // TODO: Consider building out a way to parse sortingMethod, if possible.
  static sortingMethodToJson(int Function(Entity a, Entity b)? sortingMethod) =>
      null;
  // TODO: Can this be set back to private with underscore?
  static sortingMethodFromJson(dynamic sortingMethod) => null;
}
