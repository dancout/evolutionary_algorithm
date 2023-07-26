import 'package:genetic_evolution/models/entity.dart';
import 'package:genetic_evolution/models/population.dart';
import 'package:genetic_evolution/services/entity_service.dart';
import 'package:genetic_evolution/services/selection_service.dart';

class PopulationService<T> {
  PopulationService({
    required this.entityService,
    required this.selectionService,
  });

  /// The EntityService used to populate the entities of this Population.
  final EntityService<T> entityService;

  /// Used for selecting parents of the new Population's children
  final SelectionService<T> selectionService;

  /// Returns a randomly initialized population based on the given
  /// [populationSize].
  Population<T> randomPopulation({
    required int populationSize,
  }) {
    final List<Entity<T>> entities = [];

    for (int i = 0; i < populationSize; i++) {
      entities.add(entityService.randomEntity());
    }

    return Population(entities: entities);
  }

  /// Returns a new Population of children that have been crossed over from
  /// [numParents] number of parents.
  Population<T> reproduce({
    required Population<T> population,
  }) {
    // Declare the list of new children
    final List<Entity<T>> children = [];

    for (int i = 0; i < population.entities.length; i++) {
      // Select parents for the new child
      final parents = selectionService.selectParents(
        population: population,
      );

      // Create the child from the given parents
      final child = entityService.crossOver(parents: parents);

      // Add the child to the children list
      children.add(child);
    }

    // Return the newly created Population
    return Population(entities: children);
  }
}
