import 'package:equatable/equatable.dart';
import 'package:genetic_evolution/models/entity.dart';
import 'package:genetic_evolution/models/population.dart';
import 'package:genetic_evolution/services/entity_service.dart';
import 'package:genetic_evolution/services/selection_service.dart';

/// Used for manipulating a population.
class PopulationService<T> extends Equatable {
  const PopulationService({
    required this.entityService,
    required this.selectionService,
  });

  /// The EntityService used to populate the entities of this Population.
  final EntityService<T> entityService;

  /// Used for selecting parents of the new Population's children
  final SelectionService<T> selectionService;

  /// Returns a randomly initialized population based on the given
  /// [populationSize].
  Future<Population<T>> randomPopulation({
    required int populationSize,
  }) async {
    final List<Entity<T>> entities = [];

    for (int i = 0; i < populationSize; i++) {
      entities.add(await entityService.randomEntity());
    }

    return Population(entities: entities);
  }

  /// Returns a new Population of children that have been crossed over from
  /// [numParents] number of parents.
  Future<Population<T>> reproduce({
    required Population<T> population,
    required int wave,
  }) async {
    // Declare the list of new children
    final List<Entity<T>> children = [];

    for (int i = 0; i < population.entities.length; i++) {
      // Select parents for the new child
      final parents = selectionService.selectParents(
        population: population,
      );

      // Create the child from the given parents
      final child = await entityService.crossOver(
        parents: parents,
        // TODO: I would love to get this from a provided value of some sort
        wave: wave,
      );

      // Add the child to the children list
      children.add(child);
    }

    // Return the newly created Population
    return Population(entities: children);
  }

  @override
  List<Object?> get props => [
        entityService,
        selectionService,
      ];
}
