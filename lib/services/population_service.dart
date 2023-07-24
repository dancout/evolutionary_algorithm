import 'package:evolutionary_algorithm/models/entity.dart';
import 'package:evolutionary_algorithm/models/population.dart';
import 'package:evolutionary_algorithm/services/entity_service.dart';
import 'package:evolutionary_algorithm/services/selection_service.dart';

class PopulationService {
  PopulationService({
    required this.entityService,
    required this.selectionService,
  });

  /// The EntityService used to populate the entities of this Population.
  final EntityService entityService;

  /// Used for selecting parents of the new Population's children
  final SelectionService selectionService;

  /// Returns a randomly initialized population based on the given
  /// [populationSize].
  Population randomPopulation({
    required int populationSize,
  }) {
    final List<Entity> entities = [];

    for (int i = 0; i < populationSize; i++) {
      entities.add(entityService.randomEntity());
    }

    return Population(entities: entities);
  }

  /// Returns a new Population of children that have been crossed over from
  /// [numParents] number of parents.
  Population reproduce({
    required Population population,
    required int numParents,
  }) {
    // Declare the list of new children
    final List<Entity> children = [];

    for (int i = 0; i < population.entities.length; i++) {
      // Select parents for the new child
      final parents = selectionService.selectParents(
        population: population,
        numParents: numParents,
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
