import 'package:equatable/equatable.dart';
import 'package:evolutionary_algorithm/models/entity.dart';

class Population extends Equatable {
  const Population({
    required this.entities,
  });

  /// Represents the entities present within this population.
  final List<Entity> entities;
  @override
  List<Object?> get props => [
        entities,
      ];
}

extension PopulationExtension on Population {
  /// Returns a list of entities in this population sorted in order from highest
  /// fitnessScore to lowest.
  List<Entity> get sortedEntities => entities
    ..sort(
      (a, b) => a.fitnessScore.compareTo(b.fitnessScore),
    );
}
