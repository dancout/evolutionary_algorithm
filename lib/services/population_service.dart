import 'package:evolutionary_algorithm/models/entity.dart';
import 'package:evolutionary_algorithm/models/population.dart';
import 'package:evolutionary_algorithm/services/entity_service.dart';

class PopulationService {
  PopulationService({
    required this.entityService,
  });

  /// The EntityService used to populate the entities of this Population.
  final EntityService entityService;

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
}
