import 'dart:math';

import 'package:evolutionary_algorithm/models/entity.dart';
import 'package:evolutionary_algorithm/models/population.dart';
import 'package:flutter/foundation.dart';

class SelectionService {
  SelectionService({
    required this.numParents,
    bool? canReproduceWithSelf,
    Random? random,
  })  : canReproduceWithSelf = canReproduceWithSelf ?? true,
        random = random ?? Random();

  /// Used as the internal random number generator.
  final Random random;

  /// Represents the number of parents for each Entity
  final int numParents;

  /// Indicates if an entity can reproduce with itself. If false, then the
  /// entity will be removed from the selection pool after being selected the
  /// first time.
  final bool canReproduceWithSelf;

  /// Returns a List<Entity> of parents to reproduce based on the input
  /// [population].
  List<Entity> selectParents({
    /// The population to select from.
    required Population population,
  }) {
    final List<Entity> parents = [];
    final entities = List.of(population.entities);

    for (int i = 0; i < numParents; i++) {
      // Select a parent from the pool
      final entity = selectParentFromPool(entities: entities);

      // Add this entity to the list of parents
      parents.add(entity);

      // Check if an entity can reproduce with itself
      if (!canReproduceWithSelf) {
        // Remove this entity from the selction pool.
        entities.remove(entity);
      }
    }

    return parents;
  }

  /// Returns an Entity from the input [entities] based on its probablility of
  /// being chosed.
  @visibleForTesting
  Entity selectParentFromPool({
    required List<Entity> entities,
  }) {
    // Calculate the normalized Fitness Score among all entities
    final normalizedScore = totalEntitiesFitnessScore(entities: entities);

    // Generate a random number to select against.
    double randNumber = random.nextDouble();

    // Cycle through each entity in the selection pool
    for (var entity in entities) {
      // Calculate the normalized probability of this entity
      final normalizedProbability = entity.fitnessScore / normalizedScore;
      // Subtract the probability of selecting this entity from the generated
      // random number
      randNumber -= normalizedProbability;
      // Check if we have dropped below zero, indicating this entity has been
      // selected.
      if (randNumber < 0) {
        return entity;
      }
    }

    // Theoretically, this should never be reached.
    throw Exception(
      'Cycled through all available entities and could not select a parent from'
      ' the pool. Consider adding a bias to the fitnessScore so that there are '
      'no 0 values.',
    );
  }

  /// Returns the total sum of fitness scores among the input [entities].
  @visibleForTesting
  double totalEntitiesFitnessScore({
    required List<Entity> entities,
  }) {
    return entities
        .map((e) => e.fitnessScore)
        .reduce((value, element) => value + element);
  }
}
